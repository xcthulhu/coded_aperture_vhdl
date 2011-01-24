/*
 * Specific led driver for generic led driver 
 *
 * (c) Copyright 2008	Armadeus project
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
#ifdef CONFIG_MACH_APF27 /* to be removed when MX1 platform merged */
#include <mach/fpga.h>
#endif
#include"led.h"


static struct plat_led_port plat_led0_data = {
	.name = "LED0",
	.num = 0,
	.membase = (void *)(ARMADEUS_FPGA_BASE_ADDR_VIRT + 0x8),
	.idnum = 2,
	.idoffset = 0x01 * (16 / 8),
};


void plat_led_release(struct device *dev){
	PDEBUG("device %s .released\n",dev->bus_id);
}

static struct platform_device plat_led0_device = {
	.name = "led",
	.id = 0,
	.dev = {
		.release = plat_led_release,
		.platform_data=&plat_led0_data
		},
};


static int __init sled_init(void)
{
	return platform_device_register(&plat_led0_device);
}

static void __exit sled_exit(void)
{
	printk(KERN_WARNING "deleting board_leds\n");
	platform_device_unregister(&plat_led0_device);
}

module_init(sled_init);
module_exit(sled_exit);

MODULE_AUTHOR("Fabien Marteau <fabien.marteau@armadeus.com>");
MODULE_DESCRIPTION("Driver to blink blink some leds");
MODULE_LICENSE("GPL");

