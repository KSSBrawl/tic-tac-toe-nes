.include "wram_global.inc"

.zeropage

nmi_switch:			.res 1

jump_addr:			.res 2

work:				.res 4

ppumask_shadow:			.res 1

cursor_x:			.res 1
cursor_y:			.res 1
cursor_ani_timer:		.res 1
cursor_row:			.res 1
cursor_col:			.res 1

turn:				.res 1

last_square:			.res 1

new_game_ctrl:			.res 2
game_state:			.res 1

ppu_upload_buf:			.res 80
ppu_upload_buf_ptr:		.res 1

p1_score:			.res 1
p1_score_digits:		.res 2
p2_score:			.res 1
p2_score_digits:		.res 2

joy_pressed:			.res 1
joy_held:			.res 1

sq1_sfx_queue:			.res 1
sq2_sfx_timer:			.res 1
sq2_sfx_queue:			.res 1
sq2_sfx_buf:			.res 1

ai_turn:			.res 1

.segment "OAM"

spr_cursor_1:			.res 4
spr_cursor_2:			.res 4
spr_cursor_3:			.res 4
spr_cursor_4:			.res 4

spr_p1_score_digit_1:		.res 4
spr_p1_score_digit_2:		.res 4
spr_p2_score_digit_1:		.res 4
spr_p2_score_digit_2:		.res 4

.bss

board_squares:			.res 9
