.zeropage

nmi_switch:			.res 1
.export nmi_switch

work:				.res 3
.export work

ppumask_shadow:			.res 1
.export ppumask_shadow

cursor_x:			.res 1
.export cursor_x

cursor_y:			.res 1
.export cursor_y

cursor_ani_timer:		.res 1
.export cursor_ani_timer

cursor_row:			.res 1
.export cursor_row

cursor_col:			.res 1
.export cursor_col

board_squares:			.res 9
.export board_squares

turn:				.res 1
.export turn

last_square:			.res 1
.export last_square

new_game_ctrl:			.res 2
.export new_game_ctrl

game_state:			.res 1
.export game_state

ppu_upload_buf:			.res 80
.export ppu_upload_buf

ppu_upload_buf_ptr:		.res 1
.export ppu_upload_buf_ptr

p1_score:			.res 1
.export p1_score

p1_score_digits:		.res 2
.export p1_score_digits

p2_score:			.res 1
.export p2_score

p2_score_digits:		.res 2
.export p2_score_digits

joy_pressed:			.res 1
.export joy_pressed

joy_held:			.res 1
.export joy_held

sq1_sfx_queue:			.res 1
.export sq1_sfx_queue

sq2_sfx_timer:			.res 1
.export sq2_sfx_timer

sq2_sfx_queue:			.res 1
.export sq2_sfx_queue

sq2_sfx_buf:			.res 1
.export sq2_sfx_buf

.segment "OAM"

spr_cursor_1:			.res 4
.export spr_cursor_1
spr_cursor_2:			.res 4
.export spr_cursor_2
spr_cursor_3:			.res 4
.export spr_cursor_3
spr_cursor_4:			.res 4
.export spr_cursor_4

spr_p1_score_digit_1:		.res 4
.export spr_p1_score_digit_1
spr_p1_score_digit_2:		.res 4
.export spr_p1_score_digit_2
spr_p2_score_digit_1:		.res 4
.export spr_p2_score_digit_1
spr_p2_score_digit_2:		.res 4
.export spr_p2_score_digit_2

.bss

; nothing here yet