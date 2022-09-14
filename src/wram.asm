.zeropage

nmi_switch:			.res 1
work:				.res 3

cursor_x:			.res 1
cursor_y:			.res 1
cursor_ani_timer:		.res 1
cursor_row:			.res 1
cursor_col:			.res 1

board_squares:			.res 9
turn:				.res 1
last_square:			.res 1

new_game_ctrl:			.res 2

game_state:			.res 1

ppu_upload_buf:			.res 64
ppu_upload_buf_ptr:		.res 1

joy_pressed:			.res 1
joy_held:			.res 1

sq1_sfx_timer:			.res 1
sq1_sfx_queue:			.res 1
sq2_sfx_timer:			.res 1
sq2_sfx_queue:			.res 1
sq2_sfx_buf:			.res 1

.bss

oam:				.res 256

.define	spr_cursor_1		oam+ 0
.define spr_cursor_2		oam+ 4
.define spr_cursor_3		oam+ 8
.define	spr_cursor_4		oam+12