CC=clang
CFLAGS=
OBJS=speedtest8.c hwtime.h

all: sqlite3-test sqlite3-nomem-test sqlite3-mem3-test sqlite3-mem5-test

sqlite3-test: sqlite3.o $(OBJS)
	$(CC) -o ../sqlite3-test sqlite3.o speedtest8.c $(CFLAGS)

sqlite3-nomem-test: sqlite3-nomem.o $(OBJS)
	$(CC) -o ../sqlite3-nomem-test sqlite3-nomem.o speedtest8.c $(CFLAGS)

sqlite3-mem3-test: sqlite3-mem3.o $(OBJS)
	$(CC) -o ../sqlite3-mem3-test sqlite3-mem3.o speedtest8.c $(CFLAGS)

sqlite3-mem5-test: sqlite3-mem5.o $(OBJS)
	$(CC) -o ../sqlite3-mem5-test sqlite3-mem5.o speedtest8.c $(CFLAGS)
	
bench: bench.cpp
	clang++ -o ../bench bench.cpp sqlite3-nomem.o

clean:
	rm ../sqlite3*