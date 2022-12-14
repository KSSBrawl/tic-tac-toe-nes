.include "game_defs.inc"
.include "wram_global.inc"

.export handle_turn
.export fill_square
.export check_win

.import prepare_square

;=================================================
;=================================================

.macro check_h_win row, col, no_win_label, win_label
.if col <> 0
	cmp	board_squares+(row*3)
	bne	no_win_label
.endif
.if col <> 1
	cmp	board_squares+(row*3)+1
	bne	no_win_label
.endif
.if col <> 2
	cmp	board_squares+(row*3)+2
	bne	no_win_label
.endif
.ifnblank win_label
	beq	win_label
.endif
.endmac

.macro check_v_win row, col, no_win_label, win_label
.if row <> 0
	cmp	board_squares+col
	bne	no_win_label
.endif
.if row <> 1
	cmp	board_squares+col+3
	bne	no_win_label
.endif
.if row <> 2
	cmp	board_squares+col+6
	bne	no_win_label
.endif
.ifnblank win_label
	beq	win_label
.endif
.endmac

;=================================================
;=================================================

.proc handle_turn
	lda	#JOY_A
	bit	joy_pressed
	bne	try_fill
	beq	done			; unconditional jump
square_filled:
	lda	#SFX_INVALID_ACTION
	sta	sq1_sfx_queue
done:
	rts
try_fill:
	lda	cursor_row
	asl	a			; carry remains clear
	adc	cursor_row		; a = cursor_row * 3, carry is still clear
	adc	cursor_col
	sta	last_square
	tax
	lda	board_squares,x
	bpl	square_filled		; empty square is > $80

	; fallthrough into fill_square
.endproc

.proc fill_square
	ldx	last_square
	lda	turn
	and	#$01
	sta	board_squares,x

	lda	#SFX_FILL_SQUARE
	sta	sq1_sfx_queue

	lda	last_square
	jsr	prepare_square

	lda	turn
	inc	turn
	cmp	#4			; turn 5 is the earliest that a player can win
	bcs	fallthrough
	rts
fallthrough:
	;fallthrough into check_win
.endproc

.proc check_win
	lda	last_square
	tax
	lda	board_squares,x
	bmi	done2

	lda	last_square
	asl	a
	tax
	lda	#>(check_if_game_over-1)
	pha
	lda	#<(check_if_game_over-1)
	pha

	lda	win_check_tab,x
	sta	jump_addr
	lda	win_check_tab+1,x
	sta	jump_addr+1
	jmp	(jump_addr)

check_if_game_over:
	lda	game_state
	bne	done2

; check for a draw
.repeat 9, i
	lda	board_squares+i
	bmi	done2
.endrep
	lda	#2
	sta	game_state
done2:
	rts

win_check_tab:
	.addr	check_win_square1
	.addr	check_win_square2
	.addr	check_win_square3
	.addr	check_win_square4
	.addr	check_win_square5
	.addr	check_win_square6
	.addr	check_win_square7
	.addr	check_win_square8
	.addr	check_win_square9

; x * *
; * * .
; * . *
.proc check_win_square1
	lda	board_squares
	bmi	no_win
	check_h_win 0, 0, check_for_v_win, win_found
check_for_v_win:
	check_v_win 0, 0, check_for_d_win, win_found
check_for_d_win:
	cmp	board_squares+4
	bne	no_win
	cmp	board_squares+8
	bne	no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; * x *
; . * .
; . * .
.proc check_win_square2
	lda	board_squares+1
	bmi	no_win
	check_h_win 0, 1, check_for_v_win, win_found
check_for_v_win:
	check_v_win 0, 1, no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; * * x
; . * *
; * . *
.proc check_win_square3
	lda	board_squares+2
	bmi	no_win
	check_h_win 0, 2, check_for_v_win, win_found
check_for_v_win:
	check_v_win 0, 2, check_for_d_win, win_found
check_for_d_win:
	cmp	board_squares+4
	bne	no_win
	cmp	board_squares+6
	bne	no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; * . .
; x * *
; * . .
.proc check_win_square4
	lda	board_squares+3
	bmi	no_win
	check_h_win 1, 0, check_for_v_win, win_found
check_for_v_win:
	check_v_win 1, 0, no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; * * *
; * x *
; * * *
.proc check_win_square5
	lda	board_squares+4
	bmi	no_win
	check_h_win 1, 1, check_for_v_win, win_found
check_for_v_win:
	check_v_win 1, 1, check_for_d_win_1, win_found
check_for_d_win_1:
	cmp	board_squares
	bne	check_for_d_win_2
	cmp	board_squares+8
	bne	check_for_d_win_2
	beq	win_found		; unconditional jump
check_for_d_win_2:
	cmp	board_squares+2
	bne	no_win
	cmp	board_squares+6
	bne	no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; . . *
; * * x
; . . *
.proc check_win_square6
	lda	board_squares+5
	bmi	no_win
	check_h_win 1, 2, check_for_v_win, win_found
check_for_v_win:
	check_v_win 1, 2, no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; * . *
; * * .
; x * *
.proc check_win_square7
	lda	board_squares+6
	bmi	no_win
	check_h_win 2, 0, check_for_v_win, win_found
check_for_v_win:
	check_v_win 2, 0, check_for_d_win, win_found
check_for_d_win:
	cmp	board_squares+2
	bne	no_win
	cmp	board_squares+4
	bne	no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; . * .
; . * .
; * x *
.proc check_win_square8
	lda	board_squares+7
	bmi	no_win
	check_h_win 2, 1, check_for_v_win, win_found
check_for_v_win:
	check_v_win 2, 1, no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc

; * . *
; . * *
; * * x
.proc check_win_square9
	lda	board_squares+8
	bmi	no_win
	check_h_win 2, 2, check_for_v_win, win_found
check_for_v_win:
	check_v_win 2, 2, check_for_d_win, win_found
check_for_d_win:
	cmp	board_squares
	bne	no_win
	cmp	board_squares+4
	bne	no_win
win_found:
	lda	#1
	sta	game_state
no_win:
	rts
.endproc
.endproc
