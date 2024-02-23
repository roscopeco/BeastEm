SDL2_CFLAGS=$(shell sdl2-config --cflags)
SDL2_LIBS=$(shell sdl2-config --libs)
NFD_DIR?=deps/nativefiledialog-extended-1.1.1

CXXFLAGS:=$(CXXFLAGS) $(SDL2_CFLAGS) -I$(NFD_DIR)/src/include -std=c++20 -O2
LDFLAGS:=$(LDFLAGS) -lstdc++ -lm $(SDL2_LIBS) -lSDL2_net -lSDL2_ttf -lSDL2_gfx -lSDL2_image -framework Cocoa -framework UniformTypeIdentifiers

BINARY?=beastem
OBJECTS=beastem.o 			\
		src/i2c.o		\
		src/beast.o 		\
		src/digit.o 		\
		src/display.o 		\
		src/rtc.o		\
		src/debug.o 		\
		src/listing.o 		\
		src/instructions.o 	\
		src/videobeast.o

.PHONY: all clean

all: $(BINARY)

$(NFD_DIR)/Makefile: $(NFD_DIR)/CMakeLists.txt
	cd $(NFD_DIR) && cmake .

$(NFD_DIR)/src/libnfd.a: $(NFD_DIR)/Makefile
	cd $(NFD_DIR) && make nfd

$(BINARY): $(NFD_DIR)/src/libnfd.a $(OBJECTS)

clean:
	$(RM) $(BINARY) $(OBJECTS)
	
