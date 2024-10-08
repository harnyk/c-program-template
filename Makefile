# Automatically gather all .c and .cpp files from the current directory and subdirectories
C_SOURCES = $(shell find . -name '*.c')
CPP_SOURCES = $(shell find . -name '*.cpp')

# Compiler
CC = gcc
CXX = g++

# Common flags
CFLAGS = -Wall -Werror
CXXFLAGS = -Wall -Werror

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
DEBUG_C_OBJECTS = $(C_SOURCES:%.c=$(DEBUG_OBJ_DIR)/%.o)
RELEASE_C_OBJECTS = $(C_SOURCES:%.c=$(RELEASE_OBJ_DIR)/%.o)
DEBUG_CPP_OBJECTS = $(CPP_SOURCES:%.cpp=$(DEBUG_OBJ_DIR)/%.o)
RELEASE_CPP_OBJECTS = $(CPP_SOURCES:%.cpp=$(RELEASE_OBJ_DIR)/%.o)

DEBUG_OBJECTS = $(DEBUG_C_OBJECTS) $(DEBUG_CPP_OBJECTS)
RELEASE_OBJECTS = $(RELEASE_C_OBJECTS) $(RELEASE_CPP_OBJECTS)

# Default target
all: debug

# A rule for the debug version
debug: CFLAGS += $(DEBUG_FLAGS)
debug: CXXFLAGS += $(DEBUG_FLAGS)
debug: $(DEBUG_DIR)/main

# A rule for the release version
release: CFLAGS += $(RELEASE_FLAGS)
release: CXXFLAGS += $(RELEASE_FLAGS)
release: $(RELEASE_DIR)/main

# A rule for the debug version of the executable
$(DEBUG_DIR)/main: $(DEBUG_OBJECTS) | $(DEBUG_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $(DEBUG_OBJECTS)

# A rule for the release version of the executable
$(RELEASE_DIR)/main: $(RELEASE_OBJECTS) | $(RELEASE_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $(RELEASE_OBJECTS)

# A rule for compiling each .c file into .o for debug
$(DEBUG_OBJ_DIR)/%.o: %.c | $(DEBUG_OBJ_DIR)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# A rule for compiling each .cpp file into .o for debug
$(DEBUG_OBJ_DIR)/%.o: %.cpp | $(DEBUG_OBJ_DIR)
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# A rule for compiling each .c file into .o for release
$(RELEASE_OBJ_DIR)/%.o: %.c | $(RELEASE_OBJ_DIR)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

# A rule for compiling each .cpp file into .o for release
$(RELEASE_OBJ_DIR)/%.o: %.cpp | $(RELEASE_OBJ_DIR)
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

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
