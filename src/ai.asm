.include "game_defs.inc"
.include "wram_global.inc"

.export run_ai

.import fill_square
.import check_win

;=================================================
;=================================================

.macro check_for_win_or_block no_block_label, done_label
	inc	turn
	jsr	check_for_possible_win
	dec	turn
	lda	game_state
	bne	done_label

	jsr	check_for_possible_win	; check if human player is about to win
	lda	game_state
	beq	no_block_label
	dec	game_state
	beq	done_label		; unconditional jump
.endmac

;=================================================
;=================================================

.proc run_ai
	lda	turn
	asl	a
	tax
	lda	ai_jump_table,x
	sta	jump_addr
	lda	ai_jump_table+1,x
	sta	jump_addr+1
	jmp	(jump_addr)

ai_jump_table:
	.addr	turn1
	.addr	turn2
	.addr	turn3
	.addr	turn4
	.addr	turn5
	.addr	turn6
	.addr	turn7
	.addr	turn8
	.addr	turn9

.proc turn1
	lda	#0
	sta	last_square
	jsr	fill_square
	rts
.endproc

.proc turn2
	lda	board_squares
	bpl	fill_square_5		; if square is not empty
	lda	#0
	sta	last_square	
	jmp	done
fill_square_5:
	lda	#4
	sta	last_square
done:
	jsr	fill_square
	rts
.endproc

.proc turn3
	lda	board_squares+8
	bpl	fill_square_3		; if square is not empty
	lda	#8
	sta	last_square
	jmp	done
fill_square_3:
	lda	#2
	sta	last_square
done:
	jsr	fill_square
	rts
.endproc

.proc turn4
	jsr	check_for_possible_win	; check if human player is about to win
	lda	game_state
	beq	no_block
	dec	game_state
	beq	done			; unconditional jump
no_block:
	jsr	fill_center_or_side
done:
	jsr	fill_square
	rts
.endproc

.proc turn5
	check_for_win_or_block no_block, done
no_block:
	lda	board_squares+6
	bpl	next
	lda	#6
	sta	last_square
	bne	done			; unconditional jump
next:
	lda	#2
	sta	last_square
done:
	jsr	fill_square
	rts
.endproc

.proc turn6
	check_for_win_or_block no_block, done
no_block:
	jsr	fill_center_or_side
done:
	jsr	fill_square
	rts
.endproc

.proc turn7
	check_for_win_or_block no_block, done
no_block:
	jsr	find_empty_space
done:
	jsr	fill_square
	rts
.endproc

.proc turn8
	check_for_win_or_block no_block, done
no_block:
	jsr	find_empty_space
done:
	jsr	fill_square
	rts
.endproc

.proc turn9
	jsr	find_empty_space
	jsr	fill_square
	rts
.endproc
.endproc

;=================================================
;=================================================

.proc find_empty_space
	ldx	#0
.repeat 9, i
	lda	board_squares+i
	bmi	done
	inx
.endrep
done:
	stx	last_square
	rts
.endproc

;=================================================
;=================================================

.proc fill_center_or_side
	lda	board_squares+4
	bpl	side1
	lda	#4
	sta	last_square
	bne	done			; unconditional jump
side1:
	lda	board_squares+1
	bpl	side2
	lda	#1
	sta	last_square
	bne	done			; unconditional jump
side2:
	lda	board_squares+3
	bpl	side3
	lda	#3
	sta	last_square
	bne	done			; unconditional jump
side3:
	lda	board_squares+5
	bpl	side4
	lda	#5
	sta	last_square
	bne	done			; unconditional jump
side4:
	lda	#7
	sta	last_square
done:
	rts
.endproc

;=================================================
;=================================================

.proc check_for_possible_win
	lda	turn
	sec
	sbc	#1
	and	#1
	sta	work+2
	ldx	#9
	stx	work+3
loop:
	dec	work+3
	ldx	work+3
	bmi	ret
	lda	board_squares,x
	bpl	loop			; if square is not empty
	lda	work+2
	sta	board_squares,x

	ldy	#8
win_check_loop:
	sty	last_square
	jsr	check_win
	bne	found_terminal_state	; a holds game_state, branch if win/draw found
win_check_skip:
	dey
	bpl	win_check_loop

	ldx	work+3
	lda	#$ff
	sta	board_squares,x		; undo fill
	bne	loop			; unconditional jump
found_terminal_state:
	ldx	work+3
	stx	last_square
	lda	#$ff
	sta	board_squares,x		; undo fill
ret:
	rts
.endproc
