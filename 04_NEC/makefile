# Project name (output file base name)
PROJECT = main

# Directories
SRC_DIR = src
INC_DIR = inc
BUILD_DIR = build

# Toolchain
CC = sdcc
CFLAGS = -mstm8 --std-sdcc99 -I$(INC_DIR)

# Source & object files
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.rel)

# Default target
all: $(BUILD_DIR)/$(PROJECT).ihx

# Build rules
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.rel: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/$(PROJECT).ihx: $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $@

# Flash to STM8S103F3P6
flash: $(BUILD_DIR)/$(PROJECT).ihx
	stm8flash -c stlinkv2 -p stm8s103f3 -w $<

clean_flash:
	stm8flash -c stlinkv2 -p stm8s103f3 -r /dev/null
# Clean build files
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all flash clean

