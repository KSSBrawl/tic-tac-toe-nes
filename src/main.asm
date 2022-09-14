.include "defs.asm"
.include "wram.asm"

.segment "CODE"

.proc reset
	sei
	cld
	ldx	#$ff			; init stack pointer
	txs
	inx				; x = 0
	stx	PPUCTRL			; disable PPU NMI
	stx	PPUMASK			; turn off rendering
	stx	DMCFREQ			; disable DMC IRQ

vblank1:
	bit	PPUSTATUS
	bpl	vblank1

	txa				; a = 0
clearram:
	sta	$000,x
	sta	$100,x
	sta	$200,x
	sta	$300,x
	sta	$400,x
	sta	$500,x
	sta	$600,x
	sta	$700,x
	inx
	bne	clearram

vblank2:
	bit	PPUSTATUS
	bpl	vblank2

	lda	#$0f
	sta	SNDCHN
	lda	#$40
	sta	APUFRAME

	lda	#%10000000
	sta	PPUCTRL

	jsr	init_palettes
	jsr	prepare_board
	jsr	start_new_game

.endproc

;=================================================
;=================================================

.proc main
	jsr	read_joypad
	jsr	update_cursor

	lda	#JOY_START
	bit	joy_pressed
	beq	no_start_new_game
	jsr	start_new_game
no_start_new_game:
	lda	game_state
	bne	game_over
	jsr	handle_turn
	jmp	mark_end_of_ppu_buf
game_over:
	jsr	prepare_text
mark_end_of_ppu_buf:
	ldx	ppu_upload_buf_ptr
	lda	#0
	sta	ppu_upload_buf_ptr,x

	jsr	sound_engine
	lda	#1
	sta	nmi_switch
wait_for_nmi:
	lda	nmi_switch
	bne	wait_for_nmi

	jmp	main
.endproc

;=================================================
;=================================================

.proc nmi
	php
	pha

	jsr	upload_ppu_buf
	lda	#0
	sta	ppu_upload_buf_ptr
	sta	ppu_upload_buf		; mark upload buffer as empty

	sta	nmi_switch		; = 0

	bit	PPUSTATUS		; reset address latch
	sta	PPUSCROLL
	sta	PPUSCROLL

	sta	OAMADDR
	lda	#$02
	sta	OAMDMA

	lda	#%10000000
	sta	PPUCTRL
	
	pla
	plp
	rti
.endproc

;=================================================
;=================================================

.proc irq
	rti
.endproc

;=================================================
;=================================================

.include "cursor.asm"
.include "handle_turn.asm"
.include "new_game.asm"
.include "ppu_stuff.asm"
.include "sound.asm"

;=================================================
;=================================================

;=================================================
;=================================================

.proc read_joypad
	lda	#$01
	sta	JOY1
	sta	work
	lsr	a			; carry = 1
	sta	JOY1
loop:
	lda	JOY1
	lsr	a
	rol	work
	bcc	loop

	lda	work
	sta	work+2
	eor	joy_held		; mask out buttons held on previous frame
	and	work			; mask out buttons erroneously set by previous instruction
	sta	joy_pressed
	lda	work+2
	sta	joy_held
	rts
.endproc

;=================================================
;=================================================

.segment "VECTOR"

vectors:
	.addr	nmi
	.addr	reset
	.addr	irq

.segment "CHR"

.incbin "../assets/chr0.chr"
.incbin "../assets/chr1.chr"