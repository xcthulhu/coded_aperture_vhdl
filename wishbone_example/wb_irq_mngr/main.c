/*
 * Driver for the IRQ manager (OpenCore/Wishbone based) loaded in the FPGA of 
 * the Armadeus boards.
 *
 * (C) Copyright 2008 Armadeus Systems
 * Author: Julien Boibessot <julien.boibessot@armadeus.com>
 *
 * Inspired of linux/arch/arm/mach-imx/irq.c
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* #define DEBUG */

#include <linux/module.h>
#include <linux/init.h>
#include <linux/list.h>
#include <linux/timer.h>
#include <linux/interrupt.h>
#include <linux/platform_device.h>
#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
# include <asm/hardware.h>
# include <asm/arch/irqs.h>
#else
# include <mach/hardware.h>
# include <mach/irqs.h>
#endif
#include <asm/irq.h>
#include <asm/io.h> /* readb() & Co */

#include <asm/mach/irq.h>
#ifdef CONFIG_MACH_APF27
#include <mach/fpga.h> /* To remove when MX1 platform merged */
#else
#define VA_GPIO_BASE	IO_ADDRESS(IMX_GPIO_BASE)
#define MXC_ISR(x)     (0x34 + ((x) << 8))
struct fpga_irq_mng_platform_data { /* To remove when MX1 platform merged */
	int (*init)(struct platform_device*);
	void (*exit)(struct platform_device*);
};
#endif


#define IRQ_MNGR_BASE (0x0)
#define ID (1)
#define ID_OFFSET (0x02 *(16/8))

#define NB_IT    (16)

#define FPGA_IMR (ARMADEUS_FPGA_BASE_ADDR_VIRT + IRQ_MNGR_BASE + 0x00) /* Interrupt Mask Register */
#define FPGA_ISR (ARMADEUS_FPGA_BASE_ADDR_VIRT + IRQ_MNGR_BASE + 0x02) /* Interrupt Status Register */

#define DRIVER_NAME "ocore_irq_mng"


static int
imx_fpga_irq_type(unsigned int _irq, unsigned int type)
{
	return 0;
}

static void
imx_fpga_ack_irq(unsigned int irq)
{
	int shadow;

	shadow = 1 << ((irq - IRQ_FPGA_START) % NB_IT);
	pr_debug("%s: irq %d ack:0x%x\n", __FUNCTION__, irq, shadow);
	writew(shadow, FPGA_ISR);

	/* if last IT, ack GPIO global IRQ */
	if (readw(FPGA_ISR) == 0) {
		__raw_writel(1 << (ARMADEUS_FPGA_IRQ & 0x1f),
				VA_GPIO_BASE + MXC_ISR(IRQ_TO_REG(ARMADEUS_FPGA_IRQ)));
	}
}

static void
imx_fpga_mask_irq(unsigned int irq)
{
	int shadow;

	shadow = readw(FPGA_IMR);
	shadow &= ~( 1 << ((irq - IRQ_FPGA_START) % NB_IT));
	pr_debug("%s: irq %d mask:0x%x\n", __FUNCTION__, irq, shadow);
	writew(shadow, FPGA_IMR);
}

static void
imx_fpga_unmask_irq(unsigned int irq)
{
	int shadow;

	shadow = readw(FPGA_IMR);
	shadow |= 1 << ((irq - IRQ_FPGA_START) % NB_IT);
	pr_debug("%s: irq %d mask:0x%x\n", __FUNCTION__, irq, shadow);
	writew(shadow, FPGA_IMR);
}

static void
imx_fpga_handler(unsigned int mask, unsigned int irq,
                 struct irq_desc *desc)
{
	pr_debug("%s: mask:0x%04x\n", __FUNCTION__, mask);
	desc = irq_desc + irq;
	while (mask) {
		if (mask & 1) {
			pr_debug("handling irq %d\n", irq);
			desc_handle_irq(irq, desc);
		}
		irq++;
		desc++;
		mask >>= 1;
	}
}

static void
imx_fpga_demux_handler(unsigned int irq_unused, struct irq_desc *desc)
{
	unsigned int mask, irq;

	mask = readw(FPGA_ISR);
	irq = IRQ_FPGA_START;
	imx_fpga_handler(mask, irq, desc);
}

static struct irq_chip imx_fpga_chip = {
	.name = "FPGA",
	.ack = imx_fpga_ack_irq,
	.mask = imx_fpga_mask_irq,
	.unmask = imx_fpga_unmask_irq,
	.set_type = imx_fpga_irq_type,
};


#ifdef CONFIG_PM
static int ocore_irq_mng_suspend(struct platform_device *pdev, pm_message_t state)
{
	struct fpga_irq_mng_platform_data *pdata = pdev->dev.platform_data;

	dev_dbg(&pdev->dev, "suspended\n");
	if (pdata->exit)
		pdata->exit(pdev);

	return 0;
}

static int ocore_irq_mng_resume(struct platform_device *pdev)
{
        struct fpga_irq_mng_platform_data *pdata = pdev->dev.platform_data;

	dev_dbg(&pdev->dev, "resumed\n");
	if (pdata->init)
		pdata->init(pdev);

	return 0;
}
#else

# define ocore_irq_mng_suspend NULL
# define ocore_irq_mng_resume NULL

#endif /* CONFIG_PM */

static int __devinit ocore_irq_mng_probe(struct platform_device *pdev)
{
	unsigned int irq;
	u16 data;
	int ret = 0;
	struct fpga_irq_mng_platform_data *pdata;

	pr_debug("Initializing FPGA IRQs\n");

	/* check if ID is correct */
	data = ioread16(ARMADEUS_FPGA_BASE_ADDR_VIRT + IRQ_MNGR_BASE + ID_OFFSET);
	if (data != ID) {
        	printk(KERN_WARNING "For irq_mngr id:%d doesn't match with id"
			 "read %d,\n is device present ?\n", ID, data);
        	return -ENODEV;
	}

	pdata = pdev->dev.platform_data;
	if (!pdata) {
		dev_err(&pdev->dev,"No platform_data available\n");
		return -ENOMEM;
	}

	/* Mask all interrupts initially */
	writew(0, FPGA_IMR);

	if (pdata->init) {
		ret = pdata->init(pdev);
		if (ret)
			goto failed_platform_init;
	}

	for (irq = IRQ_FPGA(0); irq < IRQ_FPGA(NB_IT); irq++) {
		pr_debug("IRQ %d\n", irq);
		set_irq_chip_and_handler(irq, &imx_fpga_chip, handle_edge_irq);
		set_irq_flags(irq, IRQF_VALID);
		/* clear pending interrrupts */ 
		imx_fpga_ack_irq(irq);
	}
	set_irq_chained_handler(ARMADEUS_FPGA_IRQ, imx_fpga_demux_handler);

	pr_debug("FPGA IRQs initialized (Parent=%d)\n", ARMADEUS_FPGA_IRQ);

	return 0;

failed_platform_init:
	return ret;
}

static int __devexit ocore_irq_mng_remove(struct platform_device *pdev)
{
	unsigned int irq;

	for (irq = IRQ_FPGA(0); irq < IRQ_FPGA(NB_IT); irq++) {
		set_irq_chip(irq, NULL);
		set_irq_handler(irq,NULL);
		set_irq_flags(irq, 0);
	}
	set_irq_chained_handler(ARMADEUS_FPGA_IRQ, NULL);

	pr_debug("%s\n", __FUNCTION__);

	return 0;
}

static struct platform_driver ocore_irq_mng_driver = {
	.probe      = ocore_irq_mng_probe,
	.remove     = ocore_irq_mng_remove,
	.suspend    = ocore_irq_mng_suspend,
	.resume     = ocore_irq_mng_resume,
	.driver     = {
		.name   = DRIVER_NAME,
	},
};

static int __init ocore_irq_mng_init(void)
{
	return platform_driver_register(&ocore_irq_mng_driver);
}

static void __exit ocore_irq_mng_exit(void)
{
	platform_driver_unregister(&ocore_irq_mng_driver);
}

module_init(ocore_irq_mng_init);
module_exit(ocore_irq_mng_exit);

MODULE_AUTHOR("Julien Boibessot, <julien.boibessot@armadeus.com>");
MODULE_DESCRIPTION("Armadeus OpenCore IRQ manager");
MODULE_LICENSE("GPL");

