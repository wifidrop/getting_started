# ----------------------------------------------------------------------------
#         ATMEL Microcontroller Software Support 
# ----------------------------------------------------------------------------
# Copyright (c) 2010, Atmel Corporation
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# - Redistributions of source code must retain the above copyright notice,
# this list of conditions and the disclaimer below.
#
# Atmel's name may not be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# DISCLAIMER: THIS SOFTWARE IS PROVIDED BY ATMEL "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT ARE
# DISCLAIMED. IN NO EVENT SHALL ATMEL BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
# OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ----------------------------------------------------------------------------

#   Makefile for compiling the CC3000 Example project

#-------------------------------------------------------------------------------
#        User-modifiable options
#-------------------------------------------------------------------------------

# Chip & board used for compilation
# (can be overriden by adding CHIP=chip and BOARD=board to the command-line)
CHIP  = sam3s2
BOARD = wifidrop

# Defines which are the available memory targets for the SAM3S-EK board.
MEMORY = flash

# Trace level used for compilation
# (can be overriden by adding TRACE_LEVEL=#number to the command-line)
# TRACE_LEVEL_DEBUG      5
# TRACE_LEVEL_INFO       4
# TRACE_LEVEL_WARNING    3
# TRACE_LEVEL_ERROR      2
# TRACE_LEVEL_FATAL      1
# TRACE_LEVEL_NO_TRACE   0
TRACE_LEVEL = 4

# Optimization level, put in comment for debugging
OPTIMIZATION = -Os

# Output file basename
TARGET = example_$(BOARD)_$(CHIP)
SRCDIR = src
ASMDIR = asm
OBJDIR = obj
INCDIR = include

BIN = bin

#-------------------------------------------------------------------------------
#		Tools
#-------------------------------------------------------------------------------

# Tool suffix when cross-compiling
CROSS_COMPILE = arm-none-eabi-

# Libraries
LIBRARIES = ./lib
# Chip library directory
CHIP_LIB = $(LIBRARIES)/libchip_sam3s
# Board library directory
BOARD_LIB = $(LIBRARIES)/libboard_$(BOARD)
# USB library directory
#USB_LIB = $(LIBRARIES)/usb

LIBS = -Wl,--start-group -lgcc -lc -lchip_$(CHIP)_gcc_dbg -lboard_$(BOARD)_gcc_dbg -Wl,--end-group

LIB_PATH = -L$(CHIP_LIB)/lib
LIB_PATH += -L$(BOARD_LIB)/lib
LIB_PATH += -L=/lib/thumb2
LIB_PATH += -L=/../lib/gcc/arm-none-eabi/4.4.1/thumb2

# Compilation tools
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
SIZE = $(CROSS_COMPILE)size
STRIP = $(CROSS_COMPILE)strip
OBJCOPY = $(CROSS_COMPILE)objcopy
GDB = $(CROSS_COMPILE)gdb
NM = $(CROSS_COMPILE)nm

# Flags
INCLUDES  = -I$(CHIP_LIB)
INCLUDES += -I$(BOARD_LIB)
INCLUDES += -I$(LIBRARIES)

CFLAGS += -Wall -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int
CFLAGS += -Werror-implicit-function-declaration -Wmain -Wparentheses
CFLAGS += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
CFLAGS += -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef
CFLAGS += -Wshadow -Wpointer-arith -Wbad-function-cast -Wwrite-strings
CFLAGS += -Wsign-compare -Waggregate-return -Wstrict-prototypes
CFLAGS += -Wmissing-prototypes -Wmissing-declarations
CFLAGS += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
CFLAGS += -Wpacked -Wredundant-decls -Wnested-externs -Winline -Wlong-long
CFLAGS += -Wunreachable-code
CFLAGS += -Wcast-align
#CFLAGS += -Wmissing-noreturn
#CFLAGS += -Wconversion

# To reduce application size use only integer printf function.
CFLAGS += -Dprintf=iprintf

# -mlong-calls  -Wall
CFLAGS += --param max-inline-insns-single=500 -mcpu=cortex-m3 -mthumb -ffunction-sections
CFLAGS += -g $(OPTIMIZATION) $(INCLUDES) -D$(CHIP) -DTRACE_LEVEL=$(TRACE_LEVEL)
ASFLAGS = -mcpu=cortex-m3 -mthumb -Wall -g $(OPTIMIZATION) $(INCLUDES) -D$(CHIP) -D__ASSEMBLY__
LDFLAGS= -mcpu=cortex-m3 -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=ResetException -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols
#LD_OPTIONAL=-Wl,--print-gc-sections -Wl,--stats

#-------------------------------------------------------------------------------
#		Files
#-------------------------------------------------------------------------------

# Directories where source files can be found

CSRC := $(foreach FILE,$(shell find $(SRCDIR) -name *.c | xargs), \
	$(subst $(SRCDIR)/, , $(FILE)))

ASRC := $(foreach FILE,$(shell find $(ASMDIR) -name *.S | xargs), \
	$(subst $(ASMDIR)/, , $(FILE)))

# Define all object files.
COBJ = $(addprefix $(OBJDIR)/,$(CSRC:.c=.o)) $(addprefix $(OBJDIR)/,$(ASRC:.S=.o))

# Define all listing files.
LST = $(ASRC:.S=.lst) $(CSRC:.c=.lst)

# Append OBJ and BIN directories to output filename
OUTPUT := $(BIN)/$(TARGET)

#-------------------------------------------------------------------------------
#		Rules
#-------------------------------------------------------------------------------

all: build

build: elf bin

elf: $(OUTPUT).elf
bin: $(OUTPUT).bin

.SUFFIXES: .elf .bin

init:
	@if [ ! -e $(OBJDIR) ]; then mkdir $(OBJDIR); fi;
	@if [ ! -e $(BIN) ]; then mkdir $(BIN); fi;
	@$(foreach DIR,$(sort $(dir $(CSRC))), if [ ! -e $(OBJDIR)/$(DIR) ]; \
		then mkdir $(OBJDIR)/$(DIR); fi; )
	@echo $(COBJ)

#$(1): $$(ASM_OBJECTS_$(1)) $$(C_OBJECTS_$(1))
#	@$(CC) $(LIB_PATH) $(LDFLAGS) $(LD_OPTIONAL) -T"$(BOARD_LIB)/resources/gcc/$(CHIP)/$$@.ld" -Wl,-Map,$(OUTPUT)-$$@.map -o $(OUTPUT)-$$@.elf $$^ $(LIBS)
#	$(NM) $(OUTPUT)-$$@.elf >$(OUTPUT)-$$@.elf.txt
#	$(OBJCOPY) -O binary $(OUTPUT)-$$@.elf $(OUTPUT)-$$@.bin
#	$(SIZE) $$^ $(OUTPUT)-$$@.elf

#$$(C_OBJECTS_$(1)): $(OBJ)/$(1)_%.o: %.c Makefile $(OBJ) $(BIN)
#	@$(CC) $(CFLAGS) -D$(1) -c -o $$@ $$<

#$$(ASM_OBJECTS_$(1)): $(OBJ)/$(1)_%.o: %.S Makefile $(OBJ) $(BIN)
#	@$(CC) $(ASFLAGS) -D$(1) -c -o $$@ $$<


.elf.bin:
	$(OBJCOPY) -O binary $< $@
	$(SIZE) $<

# Link: create ELF output file from object files.
$(OUTPUT).elf: init $(COBJ)
	$(CC) $(LIB_PATH) $(LDFLAGS) $(LD_OPTIONAL) -T"$(BOARD_LIB)/resources/gcc/$(CHIP)/$(MEMORY).ld" -Wl,-Map,$(OUTPUT).map -o $@ $(COBJ) $(LIBS)

# Compile: create object files from C source files.
$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) -c -o $@ $<

# Compile: create assembler files from C source files.
$(OBJDIR)/%.s: $(SRCDIR)/%.c
	$(CC) -S $(CFLAGS) $< -o $@

# Assemble: create object files from assembler source files.
$(OBJDIR)/%.o: $(ASMDIR)/%.S
	$(CC) -c $(ASFLAGS) $< -o $@

debug_$(1): $(1)
	$(GDB) -x "$(BOARD_LIB)/resources/gcc/$(BOARD)_$(1).gdb" -ex "reset" -readnow -se $(OUTPUT)-$(1).elf

#$(foreach MEMORY, $(MEMORIES), $(eval $(call RULES,$(MEMORY))))

clean:
	rm -rf $(OBJDIR)/* $(BIN)/*.bin $(BIN)/*.elf $(BIN)/*.map

