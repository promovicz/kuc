#CONFIG += -DNDEBUG     # disable debugging and asserts
CONFIG += -DNVALGRIND   # remove Valgrind markup
#CONFIG += -DNJIT        # disable machine code generation (AMD64 only)
#CONFIG += -DNSHORTCUT   # remove shortcut paths (reduce code size)

OBJECTS = main.o value.o alloc.o parse.o func.o code.o error.o apply.o \
                 verb.o adverb.o arith.o string.o sys.o
HEADERS =        value.h alloc.h parse.h func.h code.h error.h apply.h \
                 verb.h adverb.h arith.h string.h sys.h tree.h
TARGET  = kuc

CC      = gcc

CFLAGS  = -O3 -march=native -g \
          -std=gnu99 -fms-extensions \
          -I/usr/local/include \
          -Wall -Wextra -Wpointer-arith \
          -Wno-parentheses -Wno-attributes -Wno-unused-parameter

LIBFLAGS = -lm -ledit -ltermcap

TESTS := $(wildcard test/*.kuc)

$(TARGET): $(OBJECTS) Makefile
	$(CC) $(CFLAGS) -o $@ $(OBJECTS) $(LIBFLAGS)

.c.o:
	$(CC) $(CFLAGS) $(CONFIG) -c $<

$(OBJECTS): $(HEADERS) Makefile

.PHONY: clean
clean:
	rm -f -- $(OBJECTS) $(TARGET)

.PHONY: check
check:
	for t in ${TESTS}; do echo "/ running $$t"; ./kuc $$t; done

