SETUPLEN = 4				! nr of setup-sectors
BOOTSEG  = 0x07c0			! original address of boot-sector

entry _start
_start:
	mov	ax,#BOOTSEG
	mov	es,ax
	mov	ah,#0x03		! read cursor pos
	xor	bh,bh
	int	0x10
	
	mov	cx,#24
	mov	bx,#0x0007		! page 0, attribute 7 (normal)
	mov	bp,#msg1
	mov	ax,#0x1301		! write string, move cursor
	int	0x10

load_setup:
	mov	dx,#0x0000		! drive 0, head 0
	mov	cx,#0x0002		! sector 2, track 0
	mov	bx,#0x0200		! address = 512, in INITSEG
	mov	ax,#0x0200+SETUPLEN	! service 2, nr of sectors
	int	0x13			! read it
	jnc	ok_load_setup		! ok - continue
	mov	dx,#0x0000
	mov	ax,#0x0000		! reset the diskette
	int	0x13
	j	load_setup

ok_load_setup:
	mov	ah,#0x03		! read cursor pos
	xor	bh,bh
	int	0x10
	
	mov	cx,#18
	mov	bx,#0x0007		! page 0, attribute 7 (normal)
	mov	bp,#msg2
	mov	ax,#0x1301		! write string, move cursor
	int	0x10

	jmpi	#0x0200, #BOOTSEG

msg1:
	.byte 13,10
	.ascii "Loading system ..."
	.byte 13,10,13,10

msg2:
	.byte 13,10
	.ascii "setup loaded"
	.byte 13,10,13,10

.org 510
boot_flag:
	.word 0xAA55
