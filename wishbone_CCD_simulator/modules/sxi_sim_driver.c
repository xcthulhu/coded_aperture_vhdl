/*
 ***********************************************************************
 *
 * (c) Copyright 2011    John P. Doty
 * <jpd@noqsi.com>
 * Driver for SXI simulator IP
 *
 * Derived from code
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
#include <linux/circ_buf.h>
#include <linux/wait.h>

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
/* hardware addresses */
#	include <asm/hardware.h>
#else
#	include <mach/hardware.h>
#endif

/* for platform device */
#include <linux/platform_device.h>

/* device */
#include "sxi_driver_sim.h"

#define CB_SIZE 1024	/* circular input buffer */

/********************************
 * main device structure
 * ******************************/
struct sxi_dev {
	char *name;           /* name of the instance */
	struct cdev cdev;     /* char device structure */
	struct semaphore sem; /* mutex */
	void * membase;  /* base address for instance  */
	dev_t devno;          /* to store Major and minor numbers */
	wait_queue_head_t wait;
	struct sxi_cb { 
		int head, tail;
		int overflow;
		u16 data[CB_SIZE];
	} ccd_clocks;
};

/*
 * Circular buffer manipulation.
 */

static void cb_init( struct sxi_cb *b ) {
//	PDEBUG( "cb_init\n" );
	b->head = b->tail = b->overflow = 0;
}
	
static unsigned cb_count( struct sxi_cb *b ) {
//	PDEBUG( "cb_count\n" );
	return CIRC_CNT_TO_END( b->head, b->tail, CB_SIZE );
}

static u16 *cb_outp( struct sxi_cb *b ) {
//	PDEBUG( "cb_outp\n" );
	return b->data + b->tail;
}

static void cb_drop( unsigned n, struct sxi_cb *b ) {
//	PDEBUG( "cb_drop\n" );
	b->tail = ((b->tail + n) & (CB_SIZE-1));
}

static void cb_put( u16 d, struct sxi_cb *b ) {
//	PDEBUG( "cb_put\n" );
	if( CIRC_SPACE( b->head, b->tail, CB_SIZE ) == 0 ) {
		b->overflow += 1;
		return;
	}
	b->data[ b->head ] = d;
	b->head = ( b->head + 1) & (CB_SIZE-1);
}

static unsigned cb_space( struct sxi_cb *b ) {
//	PDEBUG( "cb_space\n" );
	return CIRC_SPACE( b->head, b->tail, CB_SIZE );
}
	
	
/***********************************
 * characters file /dev operations
 * *********************************/
ssize_t sxi_read(struct file *fildes, char __user *buff, 
                    size_t count, loff_t *offp)
{
	struct sxi_dev *ldev = fildes->private_data;
	ssize_t retval = 0;
	
	if( count & 1 ) return -EINVAL;			/* odd numbers not allowed */
	if( ldev->ccd_clocks.overflow ) return -EPIPE;	/* input buffer overflow */

//	PDEBUG( "cb_count %d\n", cb_count( &ldev->ccd_clocks));
	
	while( cb_count( &ldev->ccd_clocks) == 0 ) {	/* block */
		if(wait_event_interruptible(ldev->wait, (cb_count( &ldev->ccd_clocks))))
			return -ERESTARTSYS;
	}
	
	while( count > 0 ) {
		size_t bytes = sizeof(u16) * cb_count( &ldev->ccd_clocks);
		if( bytes == 0 ) break;
		if( bytes > count ) bytes = count;
		if (copy_to_user( buff, cb_outp( &ldev->ccd_clocks), bytes)) {
			printk(KERN_WARNING "sxi : copy to user data error\n");
			return -EFAULT;
		}
		cb_drop( bytes/sizeof(u16), &ldev->ccd_clocks);
		buff += bytes;
		count -= bytes;
		retval += bytes;
	}
	
	*offp += retval;		/* necessary? Surely harmless... -jpd */
	return retval;
}

/* Write test data into queue as if we're the interrupt handler */

ssize_t sxi_write(struct file *fildes, const char __user *buff, 
                    size_t count, loff_t *offp)
{
	struct sxi_dev *ldev = fildes->private_data;
	ssize_t retval = 0;

	if( count & 1 ) return -EINVAL;			/* odd numbers not allowed */

	/* If buffer is full, reader should be awake, so yield */
	
	while( cb_space( &ldev->ccd_clocks) == 0 ) schedule();

	while( count > 0 && cb_space(&ldev->ccd_clocks) > 0 ) {
		u16 d;
		if(copy_from_user( &d, buff, sizeof(d))) return -EFAULT;
		cb_put( d, &ldev->ccd_clocks );
		count -= sizeof(d);
		retval += sizeof(d);
		buff += sizeof(d);
	}
	
	/* wake up reading process */
	wake_up_interruptible( &ldev-> wait );	
	
	*offp += retval;
	return retval;
}	
		

int sxi_open(struct inode *inode, struct file *filp)
{
	/* find my device structure */
	
	filp->private_data = container_of(inode->i_cdev,struct sxi_dev, cdev);

	return 0;
}

int sxi_release(struct inode *inode, struct file *filp)
{
	/* Nothing to release: the device owns the data, the file doesn't */
	
	return 0;
}


static struct file_operations sxi_fops = {
	.owner = THIS_MODULE,
	.read  = sxi_read,
	.write = sxi_write,
	.open  = sxi_open,
	.release = sxi_release,
};

/**********************************
 * irq management
 * drain the FIFO
 * awake read process
 * ********************************/

static irqreturn_t sxi_interrupt(int irq, void *dev_id)
{
	struct sxi_dev *ldev = dev_id;
//	static int got_one;
	
//	if( !got_one) {
//		got_one = 1;
//		PDEBUG( "Got interrupt %s\n" , irq );
//	}

	while( ioread16(ldev->membase+SXI_STATUS) & FIFO_DATA_AVAILABLE)
		cb_put( ioread16(ldev->membase+SXI_FIFO), &ldev->ccd_clocks );
	
	/* wake up reading process */
	wake_up_interruptible( &ldev-> wait );
	
	return IRQ_HANDLED;
}

/**********************************
 * driver probe
 **********************************/
static int sxi_probe(struct platform_device *pdev)
{
	struct plat_sxi_port *dev = pdev->dev.platform_data;

	int result = 0;        /* error return */
	int sxi_major,sxi_minor;
	u16 data;
	struct sxi_dev *sdev;
	
	PDEBUG("SXI probing\n");
	PDEBUG("Register %s num %d\n",dev->name,dev->num);

	/**************************/
	/* check if ID is correct */
	/**************************/
	data = ioread16(dev->membase+SXI_ID_OFFSET);
	if (data != dev->idnum) {
		result = -1;
		printk(KERN_WARNING "For %s id:%d doesn't match "
			   "with id read %d,\n is device present ?\n",
			   dev->name,dev->idnum,data);
//		goto error_id;
	}

	/********************************************/
	/*	allocate memory for sdev structure	*/
	/********************************************/
	sdev = kmalloc(sizeof(struct sxi_dev),GFP_KERNEL);
	if (!sdev) {
		result = -ENOMEM;
		goto error_sdev_alloc;
	}
	dev->sdev = sdev;
	sdev->membase = dev->membase;
	
	/* Why must we copy the name here? -jpd */
	
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

	sxi_major = 109;
	sxi_minor = dev->num;

	sdev->devno = MKDEV(sxi_major, sxi_minor);
	result = alloc_chrdev_region(&(sdev->devno), sxi_minor, 1,dev->name);
	if (result < 0) {
		printk(KERN_WARNING "%s: can't get major %d\n",
							dev->name,sxi_major);
		goto error_devno;
	}
	printk(KERN_INFO "%s: MAJOR: %d MINOR: %d\n",
		   dev->name,
		   MAJOR(sdev->devno),
		   MINOR(sdev->devno));

	init_waitqueue_head(&sdev->wait);
	init_MUTEX(&sdev->sem);
	cb_init( &sdev->ccd_clocks );

	/****************************/
	/* Init the cdev structure  */
	/****************************/
	PDEBUG("Init the cdev structure\n");
	cdev_init(&sdev->cdev,&sxi_fops);
	sdev->cdev.owner = THIS_MODULE;
	sdev->cdev.ops   = &sxi_fops;

	PDEBUG("%s: Add the device to the kernel, "
		   "connecting cdev to major/minor number \n",dev->name);
	result = cdev_add(&sdev->cdev, sdev->devno, 1);
	if (result < 0) {
		printk(KERN_WARNING "%s: can't add cdev\n", dev->name);
		goto error_cdev_add;
	}

	/* irq registering */
	result = request_irq(dev->interrupt_number,
					sxi_interrupt,
					IRQF_SAMPLE_RANDOM,
					sdev->name,
					sdev);
	if (result < 0) {
		printk(KERN_ERR "Can't register irq %d\n",
			   dev->interrupt_number);
		goto request_irq_error;
	}
	printk(KERN_INFO "sxi: irq registered : %d\n",
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

static int __devexit sxi_remove(struct platform_device *pdev)
{
	struct plat_sxi_port *dev = pdev->dev.platform_data;
	struct sxi_dev *sdev = (*dev).sdev;

	/* freeing irq */
	free_irq(dev->interrupt_number, sdev);
//request_irq_error:
	/* delete the cdev structure */
	cdev_del(&sdev->cdev);
	PDEBUG("%s:cdev deleted\n",dev->name);
//error_cdev_add:
	/* free major and minor number */
	unregister_chrdev_region(sdev->devno, 1);
	printk(KERN_INFO "%s: SXI sim driver deleted\n", dev->name);
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

static struct platform_driver plat_sxi_driver = 
{
	.probe      = sxi_probe,
	.remove     = sxi_remove,
	.driver     = 
	{
		.name    = "sxi_sim",
//		.owner   = THIS_MODULE,
	},
};

/**********************************
 * Module management
 **********************************/
static int __init sxi_init(void)
{
	int ret;

	PDEBUG("Platform driver name %s", plat_sxi_driver.driver.name);
	ret = platform_driver_register(&plat_sxi_driver);
	if (ret) {
		printk(KERN_ERR "Platform driver register error\n");
	return ret;
	}

	return 0;
}

static void __exit sxi_exit(void)
{
	platform_driver_unregister(&plat_sxi_driver);
}

module_init(sxi_init);
module_exit(sxi_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("John Doty <jpd@noqsi.com");
MODULE_DESCRIPTION("SXI simulation driver");

