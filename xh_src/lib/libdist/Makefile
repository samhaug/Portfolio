MYLIB=$(LIBDIR)
LIB=libdist

.c.a:
	gcc -c -lm $<
	ar rv $@ $*.o
	rm -f $*.o


$(LIBDIR)/$(LIB).a: \
	$(LIBDIR)/$(LIB).a(distaz.o) \
	$(LIBDIR)/$(LIB).a(distaz2latlon.o) \
	$(LIBDIR)/$(LIB).a(vincenty.o)

