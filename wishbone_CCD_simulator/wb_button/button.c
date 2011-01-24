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

#include "button.h"

/* Internal read/write helpers */

static ssize_t button_fpga_read(void * addr, u16 *data, struct button_dev *dev)
{
	*data = ioread16(addr); /* read the button value */

	return 2;
}

static ssize_t button_fpga_write(void * addr, u16 *data, struct button_dev *dev)
{
	ssize_t retval;

	iowrite16(*data, addr); /* write the button value */
	retval = 2;

	return retval;
}

/* irq management; awake read process */
static irqreturn_t fpga_interrupt(int irq, void *dev_id, struct pt_regs *reg)
{
	struct button_dev *ldev = dev_id;
	u16 data;

	button_fpga_read(ldev->fpga_virtual_base_address + FPGA_IRQ_PEND, &data, ldev);
	PDEBUG("Interrupt raised %x\n", data);

	if (data & WB_BUTTON_IRQ) {
		/* wake up reading process */
		if (ldev->reading)
			up(&ldev->sem);
		/* acknowledge irq_mngr */
		button_fpga_write(ldev->fpga_virtual_base_address + FPGA_IRQ_ACK, &data, ldev);
		return IRQ_HANDLED;
	} else {
		return IRQ_NONE;
	}
}

/***********************************
 * characters file /dev operations
 * *********************************/
ssize_t button_read(struct file *fildes, char __user *buff, size_t count, loff_t *offp)
{
	struct button_dev *ldev = fildes->private_data;
	u16 data = 0;
	ssize_t retval = 0;
	DEFINE_WAIT(wait);

	ldev->reading = 1;

	if (*offp + count >= 1) /* Only one word can be read */
		count = 1 - *offp;

	if ((retval=down_interruptible(&ldev->sem)) < 0)
		goto out;

	if ((retval = button_fpga_read(ldev->fpga_virtual_base_address + FPGA_BUTTON, &data, ldev)) < 0)
		goto out;

	/* return data for user */
	if (copy_to_user(buff, &data, 2)) {
		printk(KERN_WARNING "read : copy to user data error\n");
		retval = -EFAULT;
		goto out;
	}

	*offp = *offp + count;
	retval = 1;

out:
	PDEBUG("read : Return value %d\n", (int)retval);
	ldev->reading = 0;

	return retval;
}

int button_open(struct inode *inode, struct file *filp)
{
	/* Allocate and fill any data structure to be put in filp->private_data */
	filp->private_data = container_of(inode->i_cdev, struct button_dev, cdev);
	PDEBUG("file opened\n");

	return 0;
}

int button_release(struct inode *inode, struct file *filp)
{
	PDEBUG("released\n");

	return 0;
}

/**********************************
 * Module management
 **********************************/
static int __init button_init(void)
{
	int result;
	int button_major, button_minor;
	u16 data;
	struct button_dev *sdev;

	button_major = 252;
	button_minor = 0;

	/* Allocate a private structure and reference it as driver's data */
	sdev = (struct button_dev *)kmalloc(sizeof(struct button_dev), GFP_KERNEL);
	if (sdev == NULL) {
		printk(KERN_WARNING "button: unable to allocate private structure\n");
		return -ENOMEM;
	}

	/* initiate mutex locked */
	sdev->reading = 0;
	init_MUTEX_LOCKED(&sdev->sem);

	/* Get the major and minor device numbers */
	PDEBUG("Get the major and minor device numbers\n");
	if (button_major) {
		devno = MKDEV(button_major, button_minor);
		result = register_chrdev_region(devno, N_DEV,BUTTON_NAME);
	} else {
		result = alloc_chrdev_region(&devno, button_minor, N_DEV, BUTTON_NAME);
		button_major = MAJOR(devno);
	}
	printk(KERN_INFO "button: MAJOR: %d MINOR: %d\n", MAJOR(devno), MINOR(devno));
	if (result < 0) {
		printk(KERN_WARNING "button: can't get major %d\n", button_major);
	}

	/* Init the cdev structure  */
	PDEBUG("Init the cdev structure\n");
	cdev_init(&sdev->cdev, &button_fops);
	sdev->cdev.owner = THIS_MODULE;

	/* Add the device to the kernel, connecting cdev to major/minor number */
	PDEBUG("Add the device to the kernel, connecting cdev to major/minor number\n");
	result = cdev_add(&sdev->cdev, devno, 1);
	if (result < 0)
		printk(KERN_WARNING "button: can't add cdev\n");

	/* Requested I/O memory */
	sdev->fpga_virtual_base_address = (void*)IMX_CS1_VIRT;

	/* irq unmask */
	data = 1 | ioread16(sdev->fpga_virtual_base_address + FPGA_IRQ_MASK);
	if ((result=button_fpga_write(sdev->fpga_virtual_base_address + FPGA_IRQ_MASK, &data, sdev)) < 0)
		goto error;

	/* irq acknowledge */
	data = 1;
	if ((result=button_fpga_write(sdev->fpga_virtual_base_address + FPGA_IRQ_ACK, &data, sdev)) < 0)
		goto error;

	/* irq registering */
	printk(KERN_INFO "button: fpga irq shared gpioa 1\n");
	if (request_irq(IRQ_GPIOA(1), (irq_handler_t)fpga_interrupt, IRQF_SHARED,BUTTON_IRQ_NAME, sdev) < 0) {
		printk(KERN_ERR "Can't request fpga irq\n");
		goto error;
	}

	/* OK driver ready ! */
	buttondev = sdev;
	printk(KERN_INFO "button module loaded\n");
	return 0;

error:
	printk(KERN_ERR "%s: not loaded\n", BUTTON_NAME);
	free_all();

	return result;
}

static void __exit button_exit(void)
{
	free_all();
}

static void free_all(void)
{
	struct button_dev *sdev = buttondev;

	/* free irq*/
	free_irq(IRQ_GPIOA(1), sdev);

	/* delete the cdev structure */
	cdev_del(&sdev->cdev);

	/* Free the allocated memory */
	kfree(sdev);

	/* Release I/O memories */
	release_mem_region(FPGA_BASE_ADDR, FPGA_MEM_SIZE);

	/* free major and minor number */
	unregister_chrdev_region(devno, N_DEV);
	printk(KERN_INFO "button module unloaded\n");
}

module_init(button_init);
module_exit(button_exit);

