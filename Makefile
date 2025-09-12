# Makefile Overview:
# ------------------
# A Makefile is a set of rules that tells the `make` tool how to build a project.
# Instead of manually typing compiler commands each time, you can run `make`
# and it will automatically compile only the files that changed, then link them
# into the final program. This saves time and reduces mistakes.

# Set the C++ compiler to use
CXX := g++

# Compiler flags:
# -std=c++17  : Use C++17 standard
# -O2         : Optimize the code for speed (level 2)
# -Wall       : Enable all common compiler warnings
# -Wextra     : Enable extra (less common) warnings
CXXFLAGS := -std=c++17 -O2 -Wall -Wextra

# Collect all .cpp source files from the "src" directory
SRC := $(wildcard src/*.cpp)

# Convert the list of .cpp files into a list of .o object files
OBJ := $(SRC:.cpp=.o)

# Name of the final executable
BIN := mariolab

# Default target: build the program
all: $(BIN)

# Rule to link object files into the final executable
$(BIN): $(OBJ)
	$(CXX) $(CXXFLAGS) $^ -o $@

# Generate assembly (.s) files without optimization
# -S : compile to assembly
# -O0: disable all optimizations
asm:
	$(CXX) -std=c++17 -O0 -S $(SRC)

# Clean up build artifacts (object files, executable, and assembly files)
clean:
	rm -f $(OBJ) $(BIN) *.s
