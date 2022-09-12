.ifndef __DEFS__
	__DEFS__ = 1

.define	JOY_A		1 << 7
.define	JOY_B		1 << 6
.define	JOY_SELECT	1 << 5
.define	JOY_START	1 << 4
.define	JOY_U		1 << 3
.define	JOY_D		1 << 2
.define	JOY_L		1 << 1
.define	JOY_R		1 << 0

.define REG_ENV		0
.define REG_LINEARCTR	0
.define REG_FREQLO	2
.define REG_FREQHI	3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PPU registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.define PPUCTRL   	$2000
.define PPUMASK   	$2001
.define PPUSTATUS 	$2002
.define OAMADDR   	$2003
.define OAMDATA   	$2004
.define PPUSCROLL 	$2005
.define PPUADDR   	$2006
.define PPUDATA   	$2007
.define OAMDMA    	$4014

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; APU registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.define SQ1VOL		$4000
.define SQ1SWEEP	$4001
.define SQ1LO		$4002
.define SQ1HI		$4003

.define SQ2VOL		$4004
.define SQ2SWEEP	$4005
.define SQ2LO		$4006
.define SQ2HI		$4007

.define TRILINEAR	$4008
;;;
.define TRILO		$400a
.define TRIHI		$400b

.define NOIVOL		$400c
;;;
.define NOIFREQ		$400e
.define NOILEN		$400f

.define DMCFREQ		$4010
.define DMCRAW		$4011
.define DMCADDR		$4012
.define DMCLEN		$4013

.define SNDCHN		$4015
.define APUFRAME	$4017

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Joypad registers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.define JOY1		$4016
.define JOY2		$4017

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Color palette constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.define COL_GRAY1	$00
.define COL_GRAY2	$10

.define COL_WHITE1	$20
.define COL_WHITE2	$30

.define COL_BLUE1	$01
.define COL_BLUE2	$11
.define COL_BLUE3	$21
.define COL_BLUE4	$31

.define COL_BLUE5	$02
.define COL_BLUE6	$12
.define COL_BLUE7	$22
.define COL_BLUE8	$32

.define COL_PURPLE1	$03
.define COL_PURPLE2	$13
.define COL_PURPLE3	$23
.define COL_PURPLE4	$33

.define COL_MAGENTA1	$04
.define COL_MAGENTA2	$14
.define COL_MAGENTA3	$24
.define COL_MAGENTA4	$34

.define COL_PINK1	$05
.define COL_PINK2	$15
.define COL_PINK3	$25
.define COL_PINK4	$35

.define COL_RED1	$06
.define COL_RED2	$16
.define COL_RED3	$26
.define COL_RED4	$36

.define COL_ORANGE1	$07
.define COL_ORANGE2	$17
.define COL_ORANGE3	$27
.define COL_ORANGE4	$37

.define COL_YELLOW1	$08
.define COL_YELLOW2	$18
.define COL_YELLOW3	$28
.define COL_YELLOW4	$38

.define COL_LIME1	$09
.define COL_LIME2	$19
.define COL_LIME3	$29
.define COL_LIME4	$39

.define COL_GREEN1	$0a
.define COL_GREEN2	$1a
.define COL_GREEN3	$2a
.define COL_GREEN4	$3a

.define COL_GREEN5	$0b
.define COL_GREEN6	$1b
.define COL_GREEN7	$2b
.define COL_GREEN8	$3b

.define COL_CYAN1	$0c
.define COL_CYAN2	$1c
.define COL_CYAN3	$2c
.define COL_CYAN4	$3c

.define COL_GRAY3	$2d
.define COL_GRAY4	$3d

.define COL_BLACK	$0f

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Game-specific defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.define game_over_text_len	.strlen("PLAYER 1 WINS!")
.define game_over_text_nt_addr	$2000+9+(32*18)
.define board_nt_addr		$2000+9+(32* 2)

.endif