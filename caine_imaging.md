# Caine

If using a Microsoft Surface laptop, you can access bios using the *volume up* key. There you can change the boot order under the menu item "Boot Configuration"

> https://www.caine-live.net/page5/page5.html

Write iso file to USB stick using Rufus:
> https://rufus.ie/en/

Image drive and ignore any bitlocker encryption - we can decrypt this afterwards using Arsenal Recon - paid for product but you can mount image without a key:
> https://arsenalrecon.com/products/arsenal-image-mounter/downloads

# Running Caine

1) In Bios: Disable Secure Boot: Secure Boot Configuration - Remove security setting so that any software can boot
2) On the boot menu select "Start Caine"
3) Attach destination drive to device
4) Open guymager - the destination device will be something similar to /dev/sdb or /dev/sdc
5) Open terminal and run command *sudo fdisk /dev/sdc* (or whatever your destination drive is called)
6) Enter *p* to print partitions and make note of the partition which is ready for data, e.g. */dev/sdc2*
7) *sudo mkdir /media/storage*
8) *sudo mount /dev/sdc2 /media/storage* 
9) Right click on the target drive and select "Acquire Image"
10) Select the destination as /media/storage, enter filename and select start


