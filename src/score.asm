.include "defs.asm"

.export   init_score_display
.export   update_score_display

.importzp p1_score
.importzp p1_score_digits
.importzp p2_score
.importzp p2_score_digits
.importzp turn
.importzp game_state

.import   spr_p1_score_digit_1
.import   spr_p1_score_digit_2
.import   spr_p2_score_digit_1
.import   spr_p2_score_digit_2

;=================================================
;=================================================

.proc init_score_display
	bit	PPUSTATUS		; reset address latch
	lda	#.hibyte(p1_score_nt_addr)
	sta	PPUADDR
	lda	#.lobyte(p1_score_nt_addr)
	sta	PPUADDR
	lda	#$50			; "P"
	sta	PPUDATA
	lda	#$31			; "1"
	sta	PPUDATA
	lda	#.hibyte(p2_score_nt_addr)
	sta	PPUADDR
	lda	#.lobyte(p2_score_nt_addr)
	sta	PPUADDR
	lda	#$50			; "P"
	sta	PPUDATA
	lda	#$32			; "2"
	sta	PPUDATA

	; write sprite
	lda	#$30
	sta	spr_p1_score_digit_1+1
	sta	spr_p2_score_digit_1+1
	sta	spr_p1_score_digit_2+1
	sta	spr_p2_score_digit_2+1
	; write X coordinate
	lda	#p1_score_text_x
	sta	spr_p1_score_digit_1+3
	lda	#p1_score_text_x+8
	sta	spr_p1_score_digit_2+3
	lda	#p2_score_text_x
	sta	spr_p2_score_digit_1+3
	lda	#p2_score_text_x+8
	sta	spr_p2_score_digit_2+3
	; write Y coordinate
	lda	#p1_score_text_y+7
	sta	spr_p1_score_digit_1+0
	sta	spr_p1_score_digit_2+0
	sta	spr_p2_score_digit_1+0
	sta	spr_p2_score_digit_2+0
	; write palette
	lda	#0
	sta	spr_p1_score_digit_1+2
	sta	spr_p1_score_digit_2+2
	sta	spr_p2_score_digit_1+2
	sta	spr_p2_score_digit_2+2

	lda	#$00
	sta	OAMADDR
	lda	#$02
	sta	OAMDMA
	rts
.endproc

;=================================================
;=================================================

.proc update_score_display
	lda	game_state
	cmp	#2
	beq	done
	
	lda	turn
	and	#$01
	beq	update_p2_score

	lda	p1_score
	cmp	#99			; has the score counter maxed out?
	beq	done
	inc	p1_score
	lda	p1_score_digits
	inc	p1_score_digits
	cmp	#9
	bne	draw_score
	lda	#0
	sta	p1_score_digits
	inc	p1_score_digits+1
	bne	draw_score		; unconditional jump
update_p2_score:
	lda	p2_score
	cmp	#99			; has the score counter maxed out?
	beq	done
	inc	p2_score
	lda	p2_score_digits
	inc	p2_score_digits
	cmp	#9
	bne	draw_score
	lda	#0
	sta	p2_score_digits
	inc	p2_score_digits+1
draw_score:
	lda	p1_score_digits+1
	clc
	adc	#$30			; translate to ASCII digit
	sta	spr_p1_score_digit_1+1
	lda	p1_score_digits
	adc	#$30			; translate to ASCII digit
	sta	spr_p1_score_digit_2+1

	lda	p2_score_digits+1
	adc	#$30			; translate to ASCII digit
	sta	spr_p2_score_digit_1+1
	lda	p2_score_digits
	adc	#$30			; translate to ASCII digit
	sta	spr_p2_score_digit_2+1
done:
	rts
.endproc