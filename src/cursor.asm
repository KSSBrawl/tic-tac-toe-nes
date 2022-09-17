.include "defs.asm"

.export update_cursor

.macro inc_cursor_pos var1, var2, exit_label
.local set_cursor_sfx_sound, cant_move_cursor
	lda	var1
	cmp	#2
	beq	cant_move_cursor
	inc	var1
	lda	var2
	clc
	adc	#40
	sta	var2
	lda	#SFX_MOVE_CURSOR
	bne	set_cursor_sfx_sound
cant_move_cursor:
	lda	#SFX_INVALID_ACTION
set_cursor_sfx_sound:
	sta	sq1_sfx_queue
	jmp	exit_label
.endmac

.macro dec_cursor_pos var1, var2, exit_label
.local set_cursor_sfx_sound, cant_move_cursor
	lda	var1
	beq	cant_move_cursor
	dec	var1
	lda	var2
	sec
	sbc	#40
	sta	var2
	lda	#SFX_MOVE_CURSOR
	bne	set_cursor_sfx_sound
cant_move_cursor:
	lda	#SFX_INVALID_ACTION
set_cursor_sfx_sound:
	sta	sq1_sfx_queue
	jmp	exit_label
.endmac

.proc update_cursor
	lda	#JOY_R
	bit	joy_pressed
	bne	move_r
	lda	#JOY_L
	bit	joy_pressed
	bne	move_l
	lda	#JOY_D
	bit	joy_pressed
	bne	move_d
	lda	#JOY_U
	bit	joy_pressed
	bne	move_u
	beq	draw_cursor

move_r:
	inc_cursor_pos cursor_col, cursor_x, draw_cursor

move_l:
	dec_cursor_pos cursor_col, cursor_x, draw_cursor

move_d:
	inc_cursor_pos cursor_row, cursor_y, draw_cursor

move_u:
	dec_cursor_pos cursor_row, cursor_y, draw_cursor

draw_cursor:
	lda	cursor_x
	sta	spr_cursor_1+3
	sta	spr_cursor_3+3
	clc
	adc	#24
	sta	spr_cursor_2+3
	sta	spr_cursor_4+3

	lda	cursor_y
	sta	spr_cursor_1+0
	sta	spr_cursor_2+0
	adc	#24			; carry still clear
	sta	spr_cursor_3+0
	sta	spr_cursor_4+0

	lda	#%00000000
	sta	spr_cursor_1+2
	lda	#%01000000
	sta	spr_cursor_2+2
	lda	#%10000000
	sta	spr_cursor_3+2
	lda	#%11000000
	sta	spr_cursor_4+2

	lda	cursor_ani_timer
	inc	cursor_ani_timer
	and	#%00010000		; check if 32 frames have passed since last animation frame
	bne	frame1
	lda	#$16
	bne	store_frame		; unconditional jump
frame1:
	lda	#$17
store_frame:
	sta	spr_cursor_1+1
	sta	spr_cursor_2+1
	sta	spr_cursor_3+1
	sta	spr_cursor_4+1

	rts
.endproc

.macro hide_cursor
	lda	#239
	sta	spr_cursor_1+3
	sta	spr_cursor_2+3
	sta	spr_cursor_3+3
	sta	spr_cursor_4+3
	rts
.endmac