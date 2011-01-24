/*
 * Driver to test OpenCore IRQ manager driver
 *
 * Copyright (C) 2008 Armadeus Systems 
 * Author: Julien Boibessot <julien.boibessot@armadeus.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */


#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
#include <linux/config.h>
#endif
#include <linux/init.h>
#include <linux/module.h>
#include <linux/interrupt.h>
#include <asm/irq.h>
#ifdef CONFIG_MACH_APF27
#include <mach/fpga.h> /* To remove when MX1 platform merged*/
#endif


/* Module's parameters: */
static int interrupt = IRQ_FPGA(3);
module_param(interrupt, int, 0000);
MODULE_PARM_DESC(interrupt, "IT to request");

#define DRIVER_NAME "IRQ test module"


static irqreturn_t fpga_interrupt(int irq,void *dev_id,struct pt_regs *reg)
{
	printk(KERN_ERR "FPGA IT n°%d\n", irq);

	return IRQ_HANDLED;
}

unsigned int data;

static int __init irq_mng_test_init(void)
{
	int result;
	
	/* IRQ registering */
	if ((result = request_irq(interrupt, (irq_handler_t)fpga_interrupt,
				/*IRQF_SHARED*/0, "ocore_irq_test", &data)) < 0) {
		printk(KERN_ERR "Can't request IRQ n°%d\n", interrupt);
		goto error;
	}
	
	printk(KERN_INFO DRIVER_NAME " inserted (IRQ %d reserved), be sure to "
		"have correspondig IP loaded in the FPGA !\n", interrupt);
	return 0;
	
error:
	return result;
}

static void __exit irq_mng_test_exit(void)
{
	printk(DRIVER_NAME " unloaded\n");
	free_irq(interrupt, 0); /* still a bug here ! */
}


module_init(irq_mng_test_init);
module_exit(irq_mng_test_exit);

MODULE_AUTHOR("Julien Boibessot, <julien.boibessot@armadeus.com>");
MODULE_DESCRIPTION("OpenCore IRQ manager IP's test driver");
MODULE_LICENSE("GPL");

