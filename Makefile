INCLUDES := -I.
LIBRARY  := -lcuda -lcudart

compile: 
	nvcc $(INCLUDES) $(LIBRARY) $(src) -o $(basename $(src)).out

clean:
	rm -f *.out