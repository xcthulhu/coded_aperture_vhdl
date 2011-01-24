/*
 ***********************************************************************
 *
 * (c) Copyright 2008    Armadeus project
 * Fabien Marteau <fabien.marteau@armadeus.com>
 * Generic driver for Wishbone button IP
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

#include <linux/init.h>
#include <linux/module.h>
#include <linux/fs.h>		/* for file  operations */
#include <linux/cdev.h>
#include <asm/uaccess.h>	/* copy_to_user function */
#include <linux/ioport.h>	/* request_mem_region */
#include <asm/io.h>		/* readw() writew() */

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
/* hardware addresses */
#	include <asm/hardware.h>
#else
#	include <mach/hardware.h>
#endif

/* for platform device */
#include <linux/platform_device.h>

/* button */
#include "button.h"


/* for debugging messages*/
//#define BUTTON_DEBUG

#undef PDEBUG
#ifdef BUTTON_DEBUG
# ifdef __KERNEL__
/* for kernel spage */
#   define PDEBUG(fmt,args...) printk(KERN_DEBUG "BUTTON : " fmt, ##args)
# else
/* for user space */
#   define PDEBUG(fmt,args...) printk(stderr, fmt, ##args)
# endif
#else
# define PDEBUG(fmt,args...) /* no debbuging message */
#endif

/********************************
 * main device structure
 * ******************************/
struct button_dev {
	char *name;           /* name of the instance */
	struct cdev cdev;     /* char device structure */
	struct semaphore sem; /* mutex */
	void * membase;  /* base address for instance  */
	dev_t devno;          /* to store Major and minor numbers */
	u8 read_in_wait;      /* user is waiting for value to read */
};

/***********************************
 * characters file /dev operations
 * *********************************/
ssize_t button_read(struct file *fildes, char __user *buff, 
                    size_t count, loff_t *offp)
{
	struct button_dev *ldev = fildes->private_data;
	u16 data=0;
	ssize_t retval = 0;

	ldev->read_in_wait = 1;

	if (*offp + count >= 1)               /* Only one word can be read */
		count = 1 - *offp;

	if ((retval=down_interruptible(&ldev->sem)) < 0) {
		goto out;
	}

	data=ioread16(ldev->membase+BUTTON_REG_OFFSET);
	PDEBUG("Read %d at 0x%x\n",data,(unsigned int)ldev->membase+BUTTON_REG_OFFSET);

	/* return data for user */
	if (copy_to_user(buff, &data, 2)) {
		printk(KERN_WARNING "read : copy to user data error\n");
		retval = -EFAULT;
		goto out;
	}

	*offp = *offp + count;
	retval = 1;

out:
	ldev->read_in_wait = 0;
	return retval;
}


int button_open(struct inode *inode, struct file *filp)
{
	/* Allocate and fill any data structure to be put in filp->private_data */
	filp->private_data = container_of(inode->i_cdev,struct button_dev, cdev);

	return 0;
}

int button_release(struct inode *inode, struct file *filp)
{
	struct button_dev *dev;

	dev = container_of(inode->i_cdev, struct button_dev, cdev);
	filp->private_data=NULL;

	return 0;
}


static struct file_operations button_fops = {
	.owner = THIS_MODULE,
	.read  = button_read,
	.open  = button_open,
	.release = button_release,
};

/**********************************
 * irq management
 * awake read process
 * ********************************/

static irqreturn_t button_interrupt(int irq, void *dev_id)
{
	struct button_dev *ldev = dev_id;

	/* wake up reading process */
	if (ldev->read_in_wait)
		up(&ldev->sem);

	return IRQ_HANDLED;
}

/**********************************
 * driver probe
 **********************************/
static int button_probe(struct platform_device *pdev)
{
	struct plat_button_port *dev = pdev->dev.platform_data;

	int result = 0;        /* error return */
	int button_major,button_minor;
	u16 data;
	struct button_dev *sdev;
	
	PDEBUG("Button probing\n");
	PDEBUG("Register %s num %d\n",dev->name,dev->num);

	/**************************/
	/* check if ID is correct */
	/**************************/
	data = ioread16(dev->membase+BUTTON_ID_OFFSET);
	if (data != dev->idnum) {
		result = -1;
		printk(KERN_WARNING "For %s id:%d doesn't match "
			   "with id read %d,\n is device present ?\n",
			   dev->name,dev->idnum,data);
		goto error_id;
	}

	/********************************************/
	/*	allocate memory for sdev structure	*/
	/********************************************/
	sdev = kmalloc(sizeof(struct button_dev),GFP_KERNEL);
	if (!sdev) {
		result = -ENOMEM;
		goto error_sdev_alloc;
	}
	dev->sdev = sdev;
	sdev->membase = dev->membase;
	sdev->name = (char *)kmalloc((1+strlen(dev->name))*sizeof(char), 
								 GFP_KERNEL);
	if (sdev->name == NULL) {
		printk("Kmalloc name space error\n");
		goto error_name_alloc;
	}
	if (strncpy(sdev->name,dev->name,1+strlen(dev->name)) < 0) {
		printk("copy error");
		goto error_name_copy;
	}

	/******************************************/
	/* Get the major and minor device numbers */
	/******************************************/

	button_major = 251;
	button_minor = dev->num;

	sdev->devno = MKDEV(button_major, button_minor);
	result = alloc_chrdev_region(&(sdev->devno), button_minor, 1,dev->name);
	if (result < 0) {
		printk(KERN_WARNING "%s: can't get major %d\n",
							dev->name,button_major);
		goto error_devno;
	}
	printk(KERN_INFO "%s: MAJOR: %d MINOR: %d\n",
		   dev->name,
		   MAJOR(sdev->devno),
		   MINOR(sdev->devno));

	/* initiate mutex locked */
	sdev->read_in_wait = 0;
	init_MUTEX_LOCKED(&sdev->sem);

	/****************************/
	/* Init the cdev structure  */
	/****************************/
	PDEBUG("Init the cdev structure\n");
	cdev_init(&sdev->cdev,&button_fops);
	sdev->cdev.owner = THIS_MODULE;
	sdev->cdev.ops   = &button_fops;

	PDEBUG("%s: Add the device to the kernel, "
		   "connecting cdev to major/minor number \n",dev->name);
	result = cdev_add(&sdev->cdev, sdev->devno, 1);
	if (result < 0) {
		printk(KERN_WARNING "%s: can't add cdev\n", dev->name);
		goto error_cdev_add;
	}

	/* irq registering */
	result = request_irq(dev->interrupt_number,
					button_interrupt,
					IRQF_SAMPLE_RANDOM,
					sdev->name,
					sdev);
	if (result < 0) {
		printk(KERN_ERR "Can't register irq %d\n",
			   dev->interrupt_number);
		goto request_irq_error;
	}
	printk(KERN_INFO "button: irq registered : %d\n",
		dev->interrupt_number);
   
	/* OK driver ready ! */
	printk(KERN_INFO "%s loaded\n", dev->name);
	return 0;

	/*********************/
	/* Errors management */
	/*********************/
	/* freeing irq */
	free_irq(dev->interrupt_number, sdev);
request_irq_error:
	/* delete the cdev structure */
	cdev_del(&sdev->cdev);
	PDEBUG("%s:cdev deleted\n", dev->name);
error_cdev_add:
	/* free major and minor number */
	unregister_chrdev_region(sdev->devno, 1);
	printk(KERN_INFO "%s: Led deleted\n", dev->name);
error_devno:
error_name_copy:
	kfree(sdev->name);
error_name_alloc:
	kfree(sdev);
error_sdev_alloc:
	printk(KERN_ERR "%s: not loaded\n", dev->name);
error_id:
	return result;
}

static int __devexit button_remove(struct platform_device *pdev)
{
	struct plat_button_port *dev = pdev->dev.platform_data;
	struct button_dev *sdev = (*dev).sdev;

	/* freeing irq */
	free_irq(dev->interrupt_number, sdev);
//request_irq_error:
	/* delete the cdev structure */
	cdev_del(&sdev->cdev);
	PDEBUG("%s:cdev deleted\n",dev->name);
//error_cdev_add:
	/* free major and minor number */
	unregister_chrdev_region(sdev->devno, 1);
	printk(KERN_INFO "%s: Led deleted\n", dev->name);
//error_devno:
//error_name_copy:
	kfree(sdev->name);
//error_name_alloc:
	kfree(sdev);
//error_sdev_alloc:
	printk(KERN_INFO "%s: deleted with success\n", dev->name);
//error_id:
	return 0;

}

static struct platform_driver plat_button_driver = 
{
	.probe      = button_probe,
	.remove     = __devexit_p(button_remove),
	.driver     = 
	{
		.name    = "button",
		.owner   = THIS_MODULE,
	},
};

/**********************************
 * Module management
 **********************************/
static int __init button_init(void)
{
	int ret;

	PDEBUG("Platform driver name %s", plat_button_driver.driver.name);
	ret = platform_driver_register(&plat_button_driver);
	if (ret) {
		printk(KERN_ERR "Platform driver register error\n");
	return ret;
	}

	return 0;
}

static void __exit button_exit(void)
{
	platform_driver_unregister(&plat_button_driver);
}

module_init(button_init);
module_exit(button_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Fabien Marteau <fabien.marteau@armadeus.com> "
			  "- ARMadeus Systems");
MODULE_DESCRIPTION("button device generic driver");

