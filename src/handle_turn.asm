.include "defs.asm"

.export   handle_turn
.import   prepare_square

.importzp joy_pressed
.importzp sq1_sfx_queue
.importzp cursor_row
.importzp cursor_col
.importzp board_squares
.importzp last_square
.importzp turn
.importzp game_state
.importzp sq2_sfx_queue

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
square_already_filled:
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
	bpl	square_already_filled	; empty square is > $80
	lda	turn
	and	#$01
	sta	board_squares,x

	lda	#SFX_FILL_SQUARE
	sta	sq1_sfx_queue

	lda	last_square
	jsr	prepare_square

	inc	turn

check_win:
	lda	last_square
	asl	a
	tax

	lda	#>(check_if_game_over-1)
	pha
	lda	#<(check_if_game_over-1)
	pha

	lda	win_check_tab+1,x
	pha
	lda	win_check_tab,x
	pha

	rts				; jump to win check subroutine

check_if_game_over:
	lda	game_state
	sta	sq2_sfx_queue
	bne	done2

; check for a draw
.repeat 9, i
	lda	board_squares+i
	bmi	done2
.endrep
	lda	#2
	sta	game_state
	sta	sq2_sfx_queue
	bne	done2			; unconditional jump
done2:
	rts

win_check_tab:
	.addr	check_win_square1-1
	.addr	check_win_square2-1
	.addr	check_win_square3-1
	.addr	check_win_square4-1
	.addr	check_win_square5-1
	.addr	check_win_square6-1
	.addr	check_win_square7-1
	.addr	check_win_square8-1
	.addr	check_win_square9-1

; x * *
; * * .
; * . *
.proc check_win_square1
	lda	board_squares
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