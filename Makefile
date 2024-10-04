# List of source files
SOURCES = main.c

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
OBJ_DIR = $(BUILD_DIR)/obj

# Transformation of source files into object files (in the directory $(OBJ_DIR))
OBJECTS = $(addprefix $(OBJ_DIR)/,$(SOURCES:.c=.o))

# Default target
all: debug

# A rule for the debug version
debug: CFLAGS += $(DEBUG_FLAGS)
debug: $(DEBUG_DIR)/main

# A rule for the release version
release: CFLAGS += $(RELEASE_FLAGS)
release: $(RELEASE_DIR)/main

# A rule for the debug version of the executable
$(DEBUG_DIR)/main: $(OBJECTS) | $(DEBUG_DIR)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS)

# A rule for the release version of the executable
$(RELEASE_DIR)/main: $(OBJECTS) | $(RELEASE_DIR)
	$(CC) $(CFLAGS) -o $@ $(OBJECTS)

# A rule for compiling each .c file into .o (object files are placed in $(OBJ_DIR))
$(OBJ_DIR)/%.o: %.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create directories if they don't exist
$(OBJ_DIR) $(DEBUG_DIR) $(RELEASE_DIR):
	mkdir -p $@

# Clean the build directory
clean:
	rm -rf $(BUILD_DIR)

# Clean the build and release directories
distclean: clean

# Additional aliases for the build
.PHONY: all debug release clean distclean