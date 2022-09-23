.ifndef __NES_DEFS__
        __NES_DEFS__ = 1

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

;=================================================
; PPU registers
;=================================================

.define PPUCTRL   	$2000
.define PPUMASK   	$2001
.define PPUSTATUS 	$2002
.define OAMADDR   	$2003
.define OAMDATA   	$2004
.define PPUSCROLL 	$2005
.define PPUADDR   	$2006
.define PPUDATA   	$2007
.define OAMDMA    	$4014

;=================================================
; APU registers
;=================================================

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

;=================================================
; Joypad registers
;=================================================

.define JOY1		$4016
.define JOY2		$4017

;=================================================
; Color palette constants
;=================================================

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

;=================================================
; APU length counter constants
;=================================================

;
.define APU_LC_254	$01 << 3
.define APU_LC_020	$02 << 3
.define APU_LC_002	$03 << 3
.define APU_LC_040	$04 << 3
.define APU_LC_004	$05 << 3
.define APU_LC_080	$06 << 3
.define APU_LC_006	$07 << 3
.define APU_LC_160	$08 << 3
.define APU_LC_008	$09 << 3
.define APU_LC_060	$0a << 3
; duplicate 010
.define APU_LC_014	$0c << 3
; duplicate 012
.define APU_LC_026	$0e << 3
; duplicate 014
; duplicate 012
.define APU_LC_016	$11 << 3
.define APU_LC_024	$12 << 3
.define APU_LC_018	$13 << 3
.define APU_LC_048	$14 << 3
; duplicate 020
.define APU_LC_096	$16 << 3
.define APU_LC_022	$17 << 3
.define APU_LC_192	$18 << 3
; duplicate 024
.define APU_LC_072	$1a << 3
; duplicate 026
; duplicate 016
.define APU_LC_028	$1d << 3
.define APU_LC_032	$1e << 3
.define APU_LC_030	$1f << 3

;=================================================
; Mapper register defines
;=================================================

.define MMC3BANKSEL	$8000
.define MMC3BANKDATA	$8001
.define MMC3MIRROR	$a000
.define MMC3PRGRAM	$a001
.define MMC3IRQLATCH	$c000
.define MMC3IRQLOAD	$c001
.define MMC3IRQOFF	$e000
.define MMC3IRQON	$e001

;=================================================
; Utility macros
;=================================================

; Calculates absolute offset within the PPU nametable of x,y coordinates
.define XY_TO_NT_ADDR(xc,yc)	$2000+(xc/8)+(yc*4)

; Calculates relative offset within the PPU nametable of x,y coordinates
.define XY_TO_NT_COOR(xc,yc)	(xc/8)+(yc*4)

.endif
