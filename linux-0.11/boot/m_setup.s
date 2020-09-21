BOOTSEG  = 0x07c0                       ! original address of boot-sectoro

entry _start
_start:
	mov	ax,#BOOTSEG
	mov	es,ax
	mov	ah,#0x03		! read cursor pos
	xor	bh,bh
	int	0x10
	
	mov	cx,#17
	mov	bx,#0x0007		! page 0, attribute 7 (normal)
	mov	bp,#msg1
	add	bp,#0x0200
	mov	ax,#0x1301		! write string, move cursor
	int	0x10

go:	j 	go

msg1:
	.byte 13,10
	.ascii "setuping..."
	.byte 13,10,13,10
