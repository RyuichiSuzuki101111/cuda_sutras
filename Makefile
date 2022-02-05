INCLUDES := -I.
LIBRARY  := -lcuda -lcudart

a.out: chap2_02.cu
	nvcc $(INCLUDES) $(LIBRARY) -o $@ $<

clean:
	rm -f a.out
