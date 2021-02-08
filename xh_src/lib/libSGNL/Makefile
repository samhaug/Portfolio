MYLIB =  $(LIBDIR)

.c.a:
	gcc -c $<
	ar rv $@ $*.o
	rm -f $*.o


MAKE = make

$(MYLIB)/libSGNL.a: \
	$(MYLIB)/libSGNL.a(DComplex.o) \
	$(MYLIB)/libSGNL.a(bpf.o) \
	$(MYLIB)/libSGNL.a(bpfilter.o) \
	$(MYLIB)/libSGNL.a(crosscor.o) \
	$(MYLIB)/libSGNL.a(deconvolve.o) \
	$(MYLIB)/libSGNL.a(detrend.o) \
	$(MYLIB)/libSGNL.a(envelope.o) \
	$(MYLIB)/libSGNL.a(dfft.o) \
	$(MYLIB)/libSGNL.a(fft.o) \
	$(MYLIB)/libSGNL.a(hilbert.o) \
	$(MYLIB)/libSGNL.a(jhilbert.o) \
	$(MYLIB)/libSGNL.a(phasestacking.o) \
	$(MYLIB)/libSGNL.a(power2.o) \
	$(MYLIB)/libSGNL.a(realft.o) \
	$(MYLIB)/libSGNL.a(resample.o) \
	$(MYLIB)/libSGNL.a(stfconvolve.o) \
	$(MYLIB)/libSGNL.a(taper.o) \
	$(MYLIB)/libSGNL.a(timeshift.o) \
	$(MYLIB)/libSGNL.a(writenegval.o) \
	$(MYLIB)/libSGNL.a(writeposval.o)
	ranlib $(MYLIB)/libSGNL.a

