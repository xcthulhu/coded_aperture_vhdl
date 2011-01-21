/*
 ***********************************************************************
 *
 * (c) Copyright 2008    Armadeus project
 * Fabien Marteau <fabien.marteau@armadeus.com>
 * Specific led driver for generic led driver 
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
 **********************************************************************
 */

#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
#include <linux/config.h>
#endif

/* form module/drivers */
#include <linux/init.h>
#include <linux/module.h>

/* for platform device */
#include <linux/platform_device.h>

#include"led.h"


static struct plat_led_port plat_led_data[] = {
    {
        .name    = "led0",
        .num     = 0,
        .membase = 0x04
    },
    {
        .name    = "led1",
        .num     = 1,
        .membase = 0x06
    },
    { },
};

static struct platform_device plat_led_device = {
    .name = "led",
    .id   = 0,
    .dev  = {
        .platform_data = plat_led_data
    },
};

static int __init sled_init(void)
{
    return platform_device_register(&plat_led_device);
}

static void __exit sled_exit(void)
{
    platform_device_unregister(&plat_led_device);
}

module_init(sled_init);
module_exit(sled_exit);

MODULE_AUTHOR("Fabien Marteau <fabien.marteau@armadeus.com>");
MODULE_DESCRIPTION("Driver to blink blink some leds");
MODULE_LICENSE("GPL");

