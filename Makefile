CC=gcc
CFLAGS=-Wall -Werror -ggdb3 -O0

main: main.c
	$(CC) $(CFLAGS) -o main main.c

clean:
	rm -f main
