/*
 *
 * (c) Copyright 2011    John P. Doty
 * <jpd@noqsi.com>
 * Driver for SXI simulator IP
 *
 * Derived from code
 * (c) Copyright 2008    Armadeus project
 * Fabien Marteau <fabien.marteau@armadeus.com>
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
 */

#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
#include <linux/config.h>
#endif

#include <linux/init.h>
#include <linux/module.h>
#include <linux/platform_device.h>
#include <mach/hardware.h>
#ifdef CONFIG_MACH_APF27 /* To remove when MX1 platform merged */
#include <mach/fpga.h>
#endif

#include "sxi_driver_sim.h"

#define SXI_IRQ   IRQ_FPGA(0)


static struct plat_sxi_port plat_sxi_data = {
	.name = "sxi_sim",
	.interrupt_number = SXI_IRQ,
	.num = 0,
	.membase = (void *)(ARMADEUS_FPGA_BASE_ADDR_VIRT + 0xc),
	.idnum = 0x0523,
	.idoffset = 0x00 * (16 / 8)
};

static struct platform_device plat_sxi_device = {
	.name = "sxi_sim",
	.id = 0,
	.dev = {
		.platform_data = &plat_sxi_data
	},
};


static int __init sxi_init(void)
{
	return platform_device_register(&plat_sxi_device);
}

static void __exit sxi_exit(void)
{
	platform_device_unregister(&plat_sxi_device);
}

module_init(sxi_init);
module_exit(sxi_exit);

MODULE_AUTHOR("John P. Doty <jpd@noqsi.com");
MODULE_DESCRIPTION("SXI driver board simulator");
MODULE_LICENSE("GPL");

