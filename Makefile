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

ASFLAGS	:= --cpu 6502 --auto-import -g
LDFLAGS :=

########################################
# Directories
########################################

SRC		:= src

########################################
# Files
########################################

SRCS := \
	$(SRC)/cursor.asm \
	$(SRC)/handle_turn.asm \
	$(SRC)/ines.asm \
	$(SRC)/main.asm \
	$(SRC)/new_game.asm \
	$(SRC)/ppu_stuff.asm \
	$(SRC)/score.asm \
	$(SRC)/sound.asm \
	$(SRC)/wram.asm

OBJS := $(SRCS:.asm=.o)
DEPS := $(SRCS:.asm=.d)

########################################
# Targets
########################################

.PHONY: all clean

all: $(ROM)

$(ROM): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ -C tictactoe.cfg $^ -Ln syms.txt
	python3 gen_fceux_syms.py

$(OBJS): %.o : %.asm
	$(AS) $(ASFLAGS) --create-dep $(@:.o=.d) $< -o $@

clean:
	rm $(OBJS) $(DEPS) tictactoe.nes.0.nl tictactoe.nes.ram.nl syms.txt
	
-include $(DEPS)
