########################################
# Tools
########################################

AS 		:= ca65
LD 		:= ld65

########################################
# ROM file
########################################

ROM		:= tictactoe.nes

########################################
# Flags
########################################

ASFLAGS	:= --cpu 6502 -g
LDFLAGS :=

########################################
# Directories
########################################

SRC		:= src

########################################
# Files
########################################

SRCS := \
	$(SRC)/wram.asm \
	$(SRC)/cursor.asm \
	$(SRC)/handle_turn.asm \
	$(SRC)/ines.asm \
	$(SRC)/main.asm \
	$(SRC)/new_game.asm \
	$(SRC)/ppu_stuff.asm \
	$(SRC)/score.asm \
	$(SRC)/sound.asm

OBJS := $(SRCS:.asm=.o)
DEPS := $(SRCS:.asm=.d)

########################################
# Targets
########################################

.PHONY: all clean globals

all: globals $(ROM)

$(ROM): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ -C tictactoe.cfg $^ -Ln syms.txt
	python3 gen_fceux_syms.py

globals:
	python3 gen_wram_global_file.py

$(OBJS): %.o : %.asm
	$(AS) $(ASFLAGS) --create-dep $(@:.o=.d) $< -o $@

clean:
	rm $(OBJS) $(DEPS) $(SRC)/wram_global.asm tictactoe.nes.0.nl tictactoe.nes.ram.nl syms.txt
	
-include $(DEPS)
