#define BUTTON_NAME  "button"
#define FPGA_BUTTON     8
#define FPGA_IRQ_MASK   0
#define FPGA_IRQ_PEND   2
#define FPGA_IRQ_ACK    2

/* Fpga base address for led */
#define FPGA_BASE_ADDR IMX_CS1_PHYS
#define FPGA_MEM_SIZE  IMX_CS1_SIZE
#define BUTTON_IRQ_NAME "button"

/* interrupt position in irq_mngr */
#define WB_BUTTON_IRQ  0x0001

