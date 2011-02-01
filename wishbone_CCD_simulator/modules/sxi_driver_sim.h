/*
 ***********************************************************************
 *
 * (c) Copyright 2011    John P. Doty
 * <jpd@noqsi.com>
 * Driver for SXI simulator IP
 *
 * Derived from code
 * (c) Copyright 2007    Armadeus project
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
 **********************************************************************
 */


#ifndef __SXI_DRIVER_SIM_H__
#define __SXI_DRIVER_SIM_H__

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
/*#define SXI_DEBUG*/

#undef PDEBUG
#ifdef SXI_DEBUG
# ifdef __KERNEL__
    /* for kernel spage */
#   define PDEBUG(fmt,args...) printk(KERN_INFO "SXI : " fmt, ##args)
# else
    /* for user space */
#   define PDEBUG(fmt,args...) printk(stderr, fmt, ##args)
# endif
#else
# define PDEBUG(fmt,args...) /* no debugging message */
#endif

#define SXI_FIFO	(0x04)
#define SXI_STATUS 	(0x02)
#define SXI_ID_OFFSET  	(0x00)

#define FIFO_DATA_AVAILABLE (0x1)

/* platform device */
struct plat_sxi_port{
	const char *name;	/*instance name */
	int interrupt_number;	/* interrupt_number */
	int num;		/* instance number */
	void *membase;		/* ioremap base address */
	int idnum;		/* identity number */
	int idoffset;		/* identity relative address */
	struct sxi_dev *sdev;	/* struct for main device structure*/
};

