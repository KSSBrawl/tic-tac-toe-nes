.include "defs.asm"
.include "wram_global.asm"

.import   init_palettes
.import   prepare_board
.import   init_score_display
.import   upload_ppu_buf
.import   start_new_game
.import   update_cursor
.import   handle_turn
.import   update_score_display
.import   prepare_text
.import   sound_engine

;=================================================
;=================================================

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

	jsr	init_palettes
	jsr	prepare_board
	jsr	init_score_display

	ldx	ppu_upload_buf_ptr
	lda	#0
	sta	ppu_upload_buf_ptr,X
	jsr	upload_ppu_buf

	lda	#%10000000
	sta	PPUCTRL

	lda	#1
	sta	nmi_switch
vblank3:
	lda	nmi_switch
	bne	vblank3

	lda	#%00011110		; enable background/sprite rendering,
					; show background/sprites on leftmost 8 pixels of screen
	sta	ppumask_shadow
	
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
	lda	game_state
	cmp	#3			; have we already performed game over tasks?
	beq	mark_end_of_ppu_buf
	sta	game_state
	jsr	update_score_display
	jsr	prepare_text
	lda	#3
	sta	game_state
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
	tya
	pha
	txa
	pha

	lda	ppu_upload_buf_ptr
	beq	no_draw
	jsr	upload_ppu_buf
no_draw:
	lda	#0
	sta	ppu_upload_buf_ptr
	sta	ppu_upload_buf		; mark upload buffer as empty

	bit	PPUSTATUS		; reset address latch
	sta	PPUSCROLL
	sta	PPUSCROLL

	sta	nmi_switch

	sta	OAMADDR
	lda	#$02
	sta	OAMDMA

	lda	ppumask_shadow
	sta	PPUMASK
	
	pla
	tay
	pla
	tax
	pla
	plp
	rti
.endproc

;=================================================
;=================================================

.proc irq
	rti
.endproc

;=================================================@shadw
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