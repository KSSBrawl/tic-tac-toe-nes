.include "game_defs.inc"
.include "wram_global.inc"

.export start_new_game
.import prepare_square

;=================================================
;=================================================

.proc start_new_game
	lda	#0
	sta	game_state
	sta	turn

;-------------------------------------------------

	; clear win/stalemate text
	ldx	ppu_upload_buf_ptr

	lda	#game_over_text_len-1
	sta	ppu_upload_buf,x
	lda	#.hibyte(game_over_text_nt_addr)
	sta	ppu_upload_buf+1,x
	lda	#.lobyte(game_over_text_nt_addr)
	sta	ppu_upload_buf+2,x

	lda	#$20			; " " in ASCII
.repeat 14, i
	sta	ppu_upload_buf+3+i,x
.endrep
	txa
	adc	#17			; carry is currently clear
	tax
	stx	ppu_upload_buf_ptr

;-------------------------------------------------

	; reset cursor position
	lda	#001
	sta	cursor_row
	sta	cursor_col
	lda	#cursor_init_x
	sta	cursor_x
	lda	#cursor_init_y
	sta	cursor_y

	; reset board squares array
	lda	#$ff
	ldx	#008
squares_init_loop:
	sta	board_squares,x
	dex
	bpl	squares_init_loop

;-------------------------------------------------

	; clear tiles in board
	lda	#9
	sta	new_game_ctrl
	lda	#0
	sta	new_game_ctrl+1

clear_tiles_loop:
	lda	new_game_ctrl+1
	inc	new_game_ctrl+1
	jsr	prepare_square

	dec	new_game_ctrl
	beq	done_clearing_tiles

	ldx	ppu_upload_buf_ptr
	lda	#0
	sta	ppu_upload_buf_ptr,x
	
	lda	#1
	sta	nmi_switch
nmi_wait:
	lda	nmi_switch
	bne	nmi_wait
	jmp	clear_tiles_loop

done_clearing_tiles:
	ldx	ppu_upload_buf_ptr
	lda	#0
	sta	ppu_upload_buf_ptr,x
	rts
.endproc
