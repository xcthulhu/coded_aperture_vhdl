/*  
 *  hello-1.c - The simplest kernel module.
 *  Based on code from tutorial here: http://tldp.org/LDP/lkmpg/2.6/html/lkmpg.html
 */
#include <linux/module.h>	/* Needed by all modules */
#include <linux/kernel.h>	/* Needed for KERN_INFO */

#define DRIVER_AUTHOR "Matthew P. Wampler-Doty <mpwd@w-d.org>"
#define DRIVER_DESC   "A hello-world kernel module for the armadeus"

int init_module(void)
{
	printk(KERN_INFO "Hello world 1.\n");

	/* 
	 * A non 0 return means init_module failed; module can't be loaded. 
	 */
	return 0;
}

void cleanup_module(void)
{
	printk(KERN_INFO "Goodbye world 1.\n");
}

/* Licensing details + driver information */
MODULE_LICENSE("GPL");
MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESC);
