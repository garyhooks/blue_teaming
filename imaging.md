# Caine

If using a Microsoft Surface laptop, you can access bios using the *volume up* key. There you can change the boot order under the menu item "Boot Configuration"

> https://www.caine-live.net/page5/page5.html

Write iso file to USB stick using Rufus:
> https://rufus.ie/en/

OR use Etcher:

> https://etcher.balena.io/#download-etcher

*IMPORTANT*: It is best to use dd writing than ISO as it is more reliable when booting up

Image drive and ignore any bitlocker encryption - we can decrypt this afterwards using Arsenal Recon - paid for product but you can mount image without a key:
> https://arsenalrecon.com/products/arsenal-image-mounter/downloads

# Running Caine

Microsoft Surface bios: hold down F4 (Volume Up) as you turn on computer 

1) In Bios: Disable Secure Boot: Secure Boot Configuration - Remove security setting so that any software can boot
2) On the boot menu select "Start Caine"
3) Attach destination drive to device
4) Open guymager in order to find the correct drive - the destination device will be something similar to /dev/sdb or /dev/sdc
5) Open terminal and run command *sudo fdisk /dev/sdb* (or whatever your destination drive is called)
6) Enter *p* to print partitions and make note of the partition which is ready for data, e.g. */dev/sdb2*
7) *sudo mkdir /media/storage*
8) *sudo mount /dev/sdb2 /media/storage* 
9) Right click on the target drive and select "Acquire Image"
10) Select the destination as /media/storage, enter filename and select start

# Viewing Bitlocker encrypted data within Caine before imaging

1) lsblk to identify the windows drive - probably /dev/nvme0n1p3 or similar
2) sudo mkdir /media/bitlocker
3) sudo mkdir /media/bitlockermount
4) sudo dislocker /dev/nvme0n1p3 -p<BITLOCKER-KEY-HERE> -- /media/bitlocker
5) sudo mount -o loop /media/bitlocker/dislocker-file /media/bitlockermount/

Then you need a destination drive to copy data to:

1) lsblk to identify
2) sudo mkdir /media/destinationdrive
3) sudo mount /dev/sdc2 /media/destinationdrive

