/*
 ***********************************************************************
 *
 * (c) Copyright 2007    Armadeus project
 * Fabien Marteau <fabien.marteau@armadeus.com>
 * Driver for Wb_button IP
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


#ifndef __BUTTON_H__
#define __BUTTON_H__

#include <linux/version.h>
#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
#include <linux/config.h>
#endif

#include <linux/init.h>
#include <linux/module.h>
/* for file operations */
#include <linux/fs.h>
#include <linux/cdev.h>
#include <asm/uaccess.h>	/* copy_to_user function */
#include <linux/ioport.h>	/* request_mem_region */
#include <asm/io.h>		/* readw() writew() */

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
/* hardware addresses */
#	include <asm/hardware.h>
#	include <asm/semaphore.h>
#else
#	include <mach/hardware.h>
#	include <linux/semaphore.h>
#endif

/* interruptions */
#include <linux/interrupt.h>
#include <asm/irq.h>
#include <linux/wait.h>

/* measure time */
#include <linux/jiffies.h>
#endif

/* for debugging messages*/
/*#define BUTTON_DEBUG*/

#undef PDEBUG
#ifdef BUTTON_DEBUG
# ifdef __KERNEL__
    /* for kernel spage */
#   define PDEBUG(fmt,args...) printk(KERN_INFO "button : " fmt, ##args)
# else
    /* for user space */
#   define PDEBUG(fmt,args...) printk(stderr, fmt, ##args)
# endif
#else
# define PDEBUG(fmt,args...) /* no debugging message */
#endif

#define BUTTON_NUMBER 1

#define BUTTON_REG_OFFSET (0x02)
#define BUTTON_ID_OFFSET  (0x00)

/* platform device */
struct plat_button_port{
	const char *name;	/*instance name */
	int interrupt_number;	/* interrupt_number */
	int num;		/* instance number */
	void *membase;		/* ioremap base address */
	int idnum;		/* identity number */
	int idoffset;		/* identity relative address */
	struct button_dev *sdev;/* struct for main device structure*/
};

