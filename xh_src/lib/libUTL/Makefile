MYLIB =  $(LIBDIR)

.c.a:
	gcc -c $<
	ar rv $@ $*.o
	rm -f $*.o


MAKE = make

$(MYLIB)/libUTL.a: \
	$(MYLIB)/libUTL.a(findmin.o) \
	$(MYLIB)/libUTL.a(gettime.o) \
	$(MYLIB)/libUTL.a(get_p_rad.o) \
	$(MYLIB)/libUTL.a(get_sv_rad.o) \
	$(MYLIB)/libUTL.a(intsort.o) \
	$(MYLIB)/libUTL.a(isunderscore.o) \
	$(MYLIB)/libUTL.a(iswhite.o) \
	$(MYLIB)/libUTL.a(mean_sigma.o) \
	$(MYLIB)/libUTL.a(randnumbers.o) \
	$(MYLIB)/libUTL.a(read_cmtheader.o)
	ranlib $(MYLIB)/libUTL.a

