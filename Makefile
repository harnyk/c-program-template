# Automatically gather all .c files from the current directory and subdirectories
SOURCES = $(shell find . -name '*.c')

# Compiler
CC = gcc

# Common flags
CFLAGS = -Wall -Werror

# Debug flags (includes debugging information)
DEBUG_FLAGS = -ggdb3 -O0

# Release flags (optimization level)
RELEASE_FLAGS = -O2

# Directories for binaries and object files
BUILD_DIR = build
DEBUG_DIR = $(BUILD_DIR)/debug
RELEASE_DIR = $(BUILD_DIR)/release
DEBUG_OBJ_DIR = $(DEBUG_DIR)/obj
RELEASE_OBJ_DIR = $(RELEASE_DIR)/obj

# Transformation of source files into object files for each mode
DEBUG_OBJECTS = $(SOURCES:%.c=$(DEBUG_OBJ_DIR)/%.o)
RELEASE_OBJECTS = $(SOURCES:%.c=$(RELEASE_OBJ_DIR)/%.o)

# Default target
all: debug

# A rule for the debug version
debug: CFLAGS += $(DEBUG_FLAGS)
debug: $(DEBUG_DIR)/main

# A rule for the release version
release: CFLAGS += $(RELEASE_FLAGS)
release: $(RELEASE_DIR)/main

# A rule for the debug version of the executable
$(DEBUG_DIR)/main: $(DEBUG_OBJECTS) | $(DEBUG_DIR)
	$(CC) $(CFLAGS) -o $@ $(DEBUG_OBJECTS)

# A rule for the release version of the executable
$(RELEASE_DIR)/main: $(RELEASE_OBJECTS) | $(RELEASE_DIR)
	$(CC) $(CFLAGS) -o $@ $(RELEASE_OBJECTS)

# A rule for compiling each .c file into .o for debug
$(DEBUG_OBJ_DIR)/%.o: %.c | $(DEBUG_OBJ_DIR)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# A rule for compiling each .c file into .o for release
$(RELEASE_OBJ_DIR)/%.o: %.c | $(RELEASE_OBJ_DIR)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# Create directories if they don't exist
$(DEBUG_OBJ_DIR) $(RELEASE_OBJ_DIR) $(DEBUG_DIR) $(RELEASE_DIR):
	mkdir -p $@

# Clean the build directory
clean:
	rm -rf $(BUILD_DIR)

# Clean the build and release directories
distclean: clean

# Additional aliases for the build
.PHONY: all debug release clean distclean
