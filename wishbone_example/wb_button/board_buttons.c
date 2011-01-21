/*
 * Specific button driver for generic button driver
 *
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

#include "button.h"

#define BUTTON0_IRQ   IRQ_FPGA(0)


static struct plat_button_port plat_button0_data = {
	.name = "BUTTON0",
	.interrupt_number = BUTTON0_IRQ,
	.num = 0,
	.membase = (void *)(ARMADEUS_FPGA_BASE_ADDR_VIRT + 0xc),
	.idnum = 3,
	.idoffset = 0x00 * (16 / 8)
};

static struct platform_device plat_button0_device = {
	.name = "button",
	.id = 0,
	.dev = {
		.platform_data = &plat_button0_data
	},
};


static int __init board_button_init(void)
{
	return platform_device_register(&plat_button0_device);
}

static void __exit board_button_exit(void)
{
	platform_device_unregister(&plat_button0_device);
}

module_init(board_button_init);
module_exit(board_button_exit);

MODULE_AUTHOR("Fabien Marteau <fabien.marteau@armadeus.com>");
MODULE_DESCRIPTION("Board specific button driver");
MODULE_LICENSE("GPL");

