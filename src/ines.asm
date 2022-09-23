.segment "INES"

INESHeader:
	.byte	"NES",$1a		; Magic
	.byte	2			; # of PRG ROM banks
	.byte	1			; # of CHR ROM banks
	.byte	$40			; Flags 6
	.byte	$00			; Flags 7
	.byte	$00			; Flags 8
	.byte	$00			; Flags 9
	.byte	$00			; Flags 10
	.byte	$00,$00,$00,$00,$00	; Unused