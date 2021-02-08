MYLIB=$(LIBDIR)
LIB=libtime

.c.a:
	gcc -c $<
	ar rv $@ $*.o
	rm -f $*.o


MAKE = make

$(MYLIB)/libtime.a: \
	$(MYLIB)/$(LIB).a(dat2jday.o) \
	$(MYLIB)/$(LIB).a(jday2dat.o) \
	$(MYLIB)/$(LIB).a(isleap.o) \
	$(MYLIB)/$(LIB).a(sec2time.o) \
	$(MYLIB)/$(LIB).a(time2sec.o) \
	$(MYLIB)/$(LIB).a(timadd.o) \
	$(MYLIB)/$(LIB).a(timdif.o)
	ranlib $(MYLIB)/$(LIB).a
