MYLIB=$(LIBDIR)

.c.a:
	gcc -c  $<
	ar rv $@ $*.o
	rm -f $*.o


MAKE = make

$(MYLIB)/libXH.a: \
	$(MYLIB)/libXH.a(xh_bdsnresp.o) \
	$(MYLIB)/libXH.a(xh_copytime_te.o) \
	$(MYLIB)/libXH.a(xh_copytime_ts.o) \
	$(MYLIB)/libXH.a(xh_checkheader.o) \
	$(MYLIB)/libXH.a(xh_checkheader97.o) \
	$(MYLIB)/libXH.a(xh_cutrecord.o) \
	$(MYLIB)/libXH.a(xh_deconvolve.o) \
	$(MYLIB)/libXH.a(xh_detrend.o) \
	$(MYLIB)/libXH.a(xh_dtstar.o) \
	$(MYLIB)/libXH.a(xh_float2int.o) \
	$(MYLIB)/libXH.a(xh_insPoleZero.o) \
	$(MYLIB)/libXH.a(xh_irisresp.o) \
	$(MYLIB)/libXH.a(xh_print.o) \
	$(MYLIB)/libXH.a(xh_readhead.o) \
	$(MYLIB)/libXH.a(xh_readhead97.o) \
	$(MYLIB)/libXH.a(xh_readdata.o) \
	$(MYLIB)/libXH.a(xh_readdata97.o) \
	$(MYLIB)/libXH.a(xh_readsac.o) \
	$(MYLIB)/libXH.a(xh_readsac_silent.o) \
	$(MYLIB)/libXH.a(xh_roll.o) \
	$(MYLIB)/libXH.a(xh_setdefaults.o) \
	$(MYLIB)/libXH.a(xh_taper.o) \
	$(MYLIB)/libXH.a(xh_tediff.o) \
	$(MYLIB)/libXH.a(xh_tsdiff.o) \
	$(MYLIB)/libXH.a(xh_TsT0_diff.o) \
	$(MYLIB)/libXH.a(xh_trinetresp.o) \
	$(MYLIB)/libXH.a(xh_writeasc.o) \
	$(MYLIB)/libXH.a(xh_writeasc2.o) \
	$(MYLIB)/libXH.a(xh_writedata.o) \
	$(MYLIB)/libXH.a(xh_writehead.o) \
	$(MYLIB)/libXH.a(xh_writesac.o) \
	$(MYLIB)/libXH.a(xh_writerec.o) \
	$(MYLIB)/libXH.a(get_cmt_region.o) \
	$(MYLIB)/libXH.a(get_SP_PS_rayp.o) \
	$(MYLIB)/libXH.a(fill_cmtheader.o) \
	$(MYLIB)/libXH.a(fill_pdeheader.o) 
	ranlib $(MYLIB)/libXH.a

