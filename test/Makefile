SRCS = $(wildcard src/*.java)
OBJS = $(patsubst src/%.java, bin/%.class, $(SRCS))

default: all

all: $(OBJS)

bin:
	mkdir -p bin

bin/%.class: $(SRCS) | bin
	javac -target 11 -d bin $(SRCS)
	java -cp bin MinimalTest

clean:
	rm -rf bin
