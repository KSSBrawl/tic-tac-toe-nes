.include "nes.inc"

;=================================================
; Game-specific defines
;=================================================

.define screen_center_x		128
.define screen_center_y		112

.define board_nt_addr		XY_TO_NT_ADDR 72, 40

.define game_over_text_nt_addr	board_nt_addr + XY_TO_NT_COOR 0, 120
.define game_over_text_len	.strlen("PLAYER 1 WINS!")

.define p1_score_text_x		080
.define p1_score_text_y		016
.define p2_score_text_x		160
.define p2_score_text_y		016

.define p1_score_nt_addr	XY_TO_NT_ADDR p1_score_text_x, p1_score_text_y
.define p2_score_nt_addr	XY_TO_NT_ADDR p2_score_text_x, p2_score_text_y

.define cursor_init_x		screen_center_x-16
.define cursor_init_y		screen_center_y-33

.define SFX_MOVE_CURSOR		%00000001
.define SFX_INVALID_ACTION	%00000010
.define SFX_FILL_SQUARE		%00000100

.define	SFX_WIN			%00000001
.define SFX_STALEMATE		%00000010