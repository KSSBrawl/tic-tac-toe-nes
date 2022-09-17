.include "defs.asm"

.export sound_engine

.proc sound_engine
	lda	sq1_sfx_queue
	beq	handle_sq2_sfx
	lsr	a
	bcs	play_move_cursor_sfx
	lsr	a
	bcs	play_invalid_action_sfx
	lsr	a
	bcs	play_fill_square_sfx
	jmp	handle_sq2_sfx

;-------------------------------------------------

play_move_cursor_sfx:
	lda	#%10011100
	ldx	#$6a
	ldy	#$00 | APU_LC_004
	bne	play_sq1_sfx		; unconditional jump

play_invalid_action_sfx:
	lda	#%10011100
	ldx	#$56
	ldy	#$03 | APU_LC_020
	bne	play_sq1_sfx		; unconditional jump

play_fill_square_sfx:
	lda	#%10011100
	ldx	#$d5
	ldy	#$00 | APU_LC_004
	bne	play_sq1_sfx		; unconditional jump

;-------------------------------------------------

play_sq1_sfx:
	sta	SQ1VOL
	stx	SQ1LO
	sty	SQ1HI
	lda	#0
	sta	sq1_sfx_queue
	sta	SQ1SWEEP
	beq	handle_sq2_sfx		; unconditional jump

;-------------------------------------------------

handle_sq2_sfx:
	lda	sq2_sfx_queue
	beq	check_for_active_sq2_sfx
	sta	sq2_sfx_buf
	lsr	a
	bcs	play_win_sfx
	lsr	a
	bcs	play_stalemate_sfx
check_for_active_sq2_sfx:
	lda	sq2_sfx_buf
	lsr	a
	bcs	continue_win_sfx
	lsr	a
	bcs	continue_stalemate_sfx
done:
	rts

;-------------------------------------------------

play_win_sfx:
	lda	#5
	sta	sq2_sfx_timer
	lda	#%10011100
	ldx	#$d5
	ldy	#$00 | APU_LC_060
	bne	play_sq2_sfx		; unconditional jump

continue_win_sfx:
	dec	sq2_sfx_timer
	bne	win_sfx_done
	lda	#0
	sta	sq2_sfx_buf
	lda	#%10011100
	ldx	#$6a
	ldy	#$00 | APU_LC_030
	bne	play_sq2_sfx		; unconditional jump
win_sfx_done:
	rts

play_stalemate_sfx:
	lda	#%10011100
	ldx	#$f8
	ldy	#$03 | APU_LC_030
	bne	play_sq2_sfx		; unconditional jump

continue_stalemate_sfx:
	rts

;-------------------------------------------------

play_sq2_sfx:
	sta	SQ2VOL
	stx	SQ2LO
	sty	SQ2HI
	lda	#0
	sta	sq2_sfx_queue
	sta	SQ2SWEEP
	lda	#$0e
	sta	SNDCHN			; mute square 1
	lda	#$0f
	sta	SNDCHN
	rts
.endproc