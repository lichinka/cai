CFLAGS += -g
INCS = -I/usr/local/browndeer/include
LIBS = -lm -L/usr/local/browndeer/lib -lstdcl
OBJS = cl_test.o

all: cl_test

cl_test: $(OBJS)
	$(CC) $(CFLAGS) $(INCS) -o $@ $(OBJS) $(LIBS)

.c.o:
	$(CC) $(CFLAGS) $(DEF) $(INCS) -c $<

clean:
	rm -f *.o *.x
