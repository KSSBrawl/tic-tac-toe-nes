.proc init_palettes
	lda	#$3f
	sta	PPUADDR
	lda	#$00
	sta	PPUADDR

	ldx	#3
loop:
	lda	bg_palette,x
	sta	PPUDATA
	dex
	bpl	loop

	lda	#$3f
	sta	PPUADDR
	lda	#$11
	sta	PPUADDR

	ldx	#2
loop2:
	lda	obj_palette,x
	sta	PPUDATA
	dex
	bpl	loop2

	rts

bg_palette:
	.byte	COL_BLACK, COL_BLUE1, COL_RED1, COL_WHITE1
obj_palette:
	.byte	COL_GRAY1, COL_GRAY1, COL_GRAY1
.endproc

;=================================================
;=================================================

.proc upload_ppu_buf
	ldx	#0
loop:
	lda	ppu_upload_buf,x
	bne	not_end_of_buf
	beq	done
not_end_of_buf:
	inx
	tay
	bit	PPUSTATUS		; reset address latch
	lda	ppu_upload_buf,x
	inx
	sta	PPUADDR
	lda	ppu_upload_buf,x
	inx
	sta	PPUADDR
entry_loop:
	lda	ppu_upload_buf,x
	inx
	sta	PPUDATA
	dey
	bpl	entry_loop
	bne	loop			; x = $ff, unconditional branch
done:
	rts
.endproc

;=================================================
;=================================================

.proc prepare_board
	rows_left 	= work
	tile_loop_ctr	= work+1
	upload_addr	= work+2

	lda	#14
	sta	rows_left
	ldx	#0
	lda	#.hibyte(board_nt_addr)
	sta	upload_addr
	lda	#.lobyte(board_nt_addr)
	sta	upload_addr+1
row_start:
	lda	upload_addr
	sta	PPUADDR
	lda	upload_addr+1
	sta	PPUADDR
row_loop:
	lda	game_board_data,x
	inx
	cmp	#$ff			; is this the end of the row?
	beq	next_row
	bpl	not_tile_loop
	and	#$0f
	sta	tile_loop_ctr
	lda	game_board_data,x
	inx
tile_loop:
	sta	PPUDATA
	dec	tile_loop_ctr
	bne	tile_loop
	beq	row_loop		; unconditional jump
not_tile_loop:
	sta	PPUDATA
	bpl	row_loop		; unconditional jump
next_row:
	cpx	#45
	bne	not_end_of_array
	ldx	#0
not_end_of_array:
	lda	upload_addr+1
	clc
	adc	#32
	sta	upload_addr+1
	lda	upload_addr
	adc	#0
	sta	upload_addr

	dec	rows_left
	bne	row_start

	rts

game_board_data:
	.byte	$84, $00, $13, $84, $00, $13, $84, $00, $ff
	.byte	$84, $00, $13, $84, $00, $13, $84, $00, $ff
	.byte	$84, $00, $13, $84, $00, $13, $84, $00, $ff
	.byte	$84, $00, $13, $84, $00, $13, $84, $00, $ff
	.byte	$84, $14, $15, $84, $14, $15, $84, $14, $ff
.endproc

;=================================================
;=================================================

.proc prepare_square
	rows_left	= work
	upload_addr	= work+1

	ldx	ppu_upload_buf_ptr

	asl	a
	tay
	lda	square_addrs,y
	sta	upload_addr
	lda	square_addrs+1,y
	sta	upload_addr+1

	lda	#3
	sta	rows_left

	ldy	#0
row_start:
	lda	#3
	sta	ppu_upload_buf,x
	lda	upload_addr
	sta	ppu_upload_buf+1,x
	lda	upload_addr+1
	sta	ppu_upload_buf+2,x
	lda	new_game_ctrl
	bne	blank_tile
	lda	turn
	and	#1
	bne	o_tile
x_tile:
.repeat	4, i
	lda	x_tiles,y
	iny
	sta	ppu_upload_buf+3+i,x
.endrep
	bne	next_row

o_tile:
.repeat	4, i
	lda	o_tiles,y
	iny
	sta	ppu_upload_buf+3+i,x
.endrep
	bne	next_row

blank_tile:
	lda	#0
.repeat 4, i
	sta	ppu_upload_buf+3+i,x
.endrep

next_row:
	lda	upload_addr+1
	clc
	adc	#32
	sta	upload_addr+1
	lda	upload_addr
	adc	#0
	sta	upload_addr

	txa
	clc
	adc	#7
	tax

	dec	rows_left
	bpl	row_start

	stx	ppu_upload_buf_ptr
done:
	rts

x_tiles:
	.byte	$01, $03, $04, $02
	.byte	$06, $01, $02, $05
	.byte	$04, $02, $01, $03
	.byte	$02, $05, $06, $01

o_tiles:
	.byte	$07, $08, $09, $0a
	.byte	$0b, $00, $00, $0c
	.byte	$0d, $00, $00, $0e
	.byte	$0f, $10, $11, $12

square_addrs:
	; row 1
	.dbyt	board_nt_addr+ 0+(32* 0)
	.dbyt	board_nt_addr+ 5+(32* 0)
	.dbyt	board_nt_addr+10+(32* 0)
	; row 2
	.dbyt	board_nt_addr+ 0+(32* 5)
	.dbyt	board_nt_addr+ 5+(32* 5)
	.dbyt	board_nt_addr+10+(32* 5)
	; row 3
	.dbyt	board_nt_addr+ 0+(32*10)
	.dbyt	board_nt_addr+ 5+(32*10)
	.dbyt	board_nt_addr+10+(32*10)
.endproc

;=================================================
;=================================================

.proc prepare_text
	ldx	ppu_upload_buf_ptr
	
	lda	game_state
	cmp	#2
	bne	not_stalemate
	ldy	#stalemate_text-game_over_text_data
	bne	copy_text		; unconditional jump
not_stalemate:
	lda	turn
	and	#1
	bne	copy_p1_win_text
	ldy	#p2_wins_text-game_over_text_data
	bne	copy_text		; unconditional jump
copy_p1_win_text:
	ldy	#p1_wins_text-game_over_text_data
copy_text:
	lda	#game_over_text_len-1
	sta	ppu_upload_buf,x
	lda	#.hibyte(game_over_text_nt_addr)
	sta	ppu_upload_buf+1,x
	lda	#.lobyte(game_over_text_nt_addr)
	sta	ppu_upload_buf+2,x
.repeat 14, i
	lda	game_over_text_data+i,y
	sta	ppu_upload_buf+3+i,x
.endrep
	txa
	clc
	adc	#game_over_text_len+3
	tax
	stx	ppu_upload_buf_ptr
	rts

game_over_text_data:
p1_wins_text:
	.byte	"PLAYER 1 WINS!"
p2_wins_text:
	.byte	"PLAYER 2 WINS!"
stalemate_text:
	.byte	"     DRAW     "
.endproc