CXX = mpicc
CXXFLAGS = -Wall -O2
INC = -I.
LIB =
BINARY = master_agent
OBJECTS = main.o master.o agent.o

all: $(BINARY)

$(BINARY): $(OBJECTS)
	$(CXX) -o $(BINARY) $(OBJECTS) $(LIB)

%.o: %.c
	$(CXX) $(CXXFLAGS) $(INC) -c $<

clean:
	rm -f $(BINARY) $(OBJECTS)
