#
# NOTE: This tool assumes a consistent formatting for wram.asm
#

import sys

SEG_ZEROPAGE = 0
SEG_BSS      = 1

def main():
	wram_file = open( './src/wram.asm', 'r' )
	glob_file = open( './wram_global.asm', 'w' )
	sys.stdout = glob_file

	segment = SEG_ZEROPAGE

	for line in wram_file:
		if line[0] == '.':
			tokens = line.split()
			if len( tokens ) > 1 and tokens[1] == '"OAM"':
				segment = SEG_BSS
			continue
		if line == '\n':
			continue
		if line[0] == ';':
			continue

		tokens = line.split( ':' )
		if segment == SEG_ZEROPAGE:
			print( '.globalzp {}'.format( tokens[0] ) )
		else:
			print( '.global   {}'.format( tokens[0] ) )

	glob_file.close()

if __name__ == '__main__':
	main()