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
; Game-specific defines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.define game_over_text_len	.strlen("PLAYER 1 WINS!")
.define game_over_text_nt_addr	$2000+9+(32*18)
.define board_nt_addr		$2000+9+(32* 2)

.endif