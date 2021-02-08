MYLIB =  $(LIBDIR)
INC   = -I$(HOME)/inc

.c.a:
	gcc -c -O1 $<
	ar rv $@ $*.o
	rm -f $*.o


MAKE = make

$(MYLIB)/libATT.a: \
	$(MYLIB)/libATT.a(att_checkheader.o) \
	$(MYLIB)/libATT.a(att_readhead.o) \
	$(MYLIB)/libATT.a(att_setdefaults.o) 
	ranlib $(MYLIB)/libATT.a
