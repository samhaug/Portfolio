#XH=/u/eu/de/haugland/xh_src
XH=/home/samhaug/src/xh_src
 
include $(XH)/Makerules

LIBM    = -lm
LIBNSL  = -lnsl
LIBD    = $(LIBDIR)/libdist.a
LIBTM   = $(LIBDIR)/libtime.a
LIBAH   = $(LIBDIR)/libAH/ioroutin.o
LIBXH   = $(LIBDIR)/libXH.a
LIBSAC  = $(LIBDIR)/libSAC.a
LIBUTL  = $(LIBDIR)/libUTL.a
LIBCMT  = $(LIBDIR)/libCMT.a
LIBSGNL = $(LIBDIR)/libSGNL.a
LIBPCK  = $(LIBDIR)/libPICK.a
LIBNRC  = $(LIBDIR)/libNumRec.a
XH_INC  = -I$(XH)/inc
BINDIR  = $(XH)/bin

####################################################################



all: ascii_2xh sac_2xh xh_2sac xh_bpfilter xh_cuttrace xh_decim xh_detrend xh_envelope xh_evtstaloc xh_grepdepth xh_grepqual xh_grepchan xh_grepaz xh_grepdist xh_greprecs xh_grepstat xh_inscmt xh_insRAYtime xh_inswavf xh_insnetw xh_longhead xh_normalize xh_onehour xh_raw2vel xh_rmvchan xh_rmvdist xh_rmvstat xh_rotate xh_shorthead xh_synch xh_taper xh_describe xh_roll xh_bitesize sac_longhead

ascii_2xh:
	$(CC) -o $(BINDIR)/ascii_2xh ascii_2xh.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL)

sac_2xh:
	$(CC) -o $(BINDIR)/sac_2xh sac_2xh.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL)

sac_longhead:
	$(CC) -o $(BINDIR)/sac_longhead sac_longhead.c $(LIBXH)  $(LIBD) $(LIBPCK) ${INC} $(LIBM) ${LIBTM} ${LIBUTL}

ah_fromHJVH_2xh:
	$(CC) -o $(BINDIR)/ah_fromHJVH_2xh ah_fromHJVH_2xh.c $(LIBAH) $(LIBXH) $(LIBM) $(LIBNSL) $(LIBTM) $(LIBUTL)

ah_fromSEED_2xh:
	$(CC) -o $(BINDIR)/ah_fromSEED_2xh ah_fromSEED_2xh.c $(LIBAH) $(LIBXH) $(LIBM) $(LIBNSL) $(LIBTM) $(LIBUTL)

ah_2xh:
	$(CC) -o $(BINDIR)/ah_2xh ah_2xh.c $(LIBAH) $(LIBXH) $(LIBM) $(LIBNSL) $(LIBTM) $(LIBUTL)

excitM3_2xh:
	$(CC) -o $(BINDIR)/excitM3_2xh excitM3_2xh.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

excit_2xh:
	$(CC) -o $(BINDIR)/excit_2xh excit_2xh.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

xh_lpsyn:
	$(CC) -o $(BINDIR)/xh_lpsyn xh_lpsyn.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

qmxd_2xh:
	$(CC) -o $(BINDIR)/qmxd_2xh qmxd_2xh.c $(LIBXH) $(LIBD) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

sac_2xh_dummy:
	$(CC) -o $(BINDIR)/sac_2xh_dummy sac_2xh_dummy.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

axisem2_2xh:
	$(CC) -o $(BINDIR)/axisem2_2xh axisem2_2xh.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

axisem_2xh:
	$(CC) -o $(BINDIR)/axisem_2xh axisem_2xh.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

ses3d_2xh:
	$(CC) -o $(BINDIR)/ses3d_2xh ses3d_2xh.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) $(XH_INC)

xh_2xh:
	$(CC) -o $(BINDIR)/xh_2xh xh_2xh.c $(LIBXH) $(LIBM) $(LIBTM)

xh_95to96:
	$(CC) -o $(BINDIR)/xh_95to96 xh_95to96.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_97to98:
	$(CC) -o $(BINDIR)/xh_97to98 xh_97to98.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_96to97:
	$(CC) -o $(BINDIR)/xh_96to97 xh_96to97.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_bitesize:
	$(CC) -o $(BINDIR)/xh_bitesize xh_bitesize.c $(LIBXH) $(LIBD) $(LIBM) 

xh_2levandar:
	$(CC) -o $(BINDIR)/xh_2levandar xh_2levandar.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_2asc:
	$(CC) -o $(BINDIR)/xh_2asc xh_2asc.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_2rec:
	$(CC) -o $(BINDIR)/xh_2rec xh_2rec.c $(LIBXH) $(LIBD) $(LIBM) $(LIBTM) $(XH_INC)

xh_2sac:
	$(CC) -o $(BINDIR)/xh_2sac xh_2sac.c $(LIBXH) $(LIBM) $(LIBTM)

xh_addhypothetical:
	$(CC) -o $(BINDIR)/xh_addhypothetical  xh_addhypothetical.c $(LIBXH) $(LIBD) $(LIBPCK) ${INC} $(LIBM)

xh_beamdescribe:
	$(CC) -o $(BINDIR)/xh_beamdescribe xh_beamdescribe.c

xh_beamdescribe_zcomp:
	$(CC) -o $(BINDIR)/xh_beamdescribe_zcomp xh_beamdescribe_zcomp.c

xh_beamenergy:
	$(CC) -Wall -o $(BINDIR)/xh_beamenergy xh_beamenergy.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_3compbeamform:
	$(CC) -Wall -std=gnu99  -o $(BINDIR)/xh_3compbeamform xh_3compbeamform.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_3compbeamform_slow:
	$(CC) -Wall -std=gnu99  -o $(BINDIR)/xh_3compbeamform_slow xh_3compbeamform_slow.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_beamform_zcomp:
	$(CC) -Wall -std=gnu99 -o $(BINDIR)/xh_beamform_zcomp xh_beamform_zcomp.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_beammax:
	$(CC) -Wall -o $(BINDIR)/xh_beammax xh_beammax.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_beamnorm:
	$(CC) -Wall -o $(BINDIR)/xh_beamnorm xh_beamnorm.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_beamnorm_zcomp:
	$(CC) -Wall -std=gnu99 -o $(BINDIR)/xh_beamnorm_zcomp xh_beamnorm_zcomp.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_beampierce:
	$(CC) -o $(BINDIR)/xh_beampierce xh_beampierce.c

xh_beamslice:
	$(CC) -o $(BINDIR)/xh_beamslice xh_beamslice.c

xh_beamvesp:
	$(CC) -o $(BINDIR)/xh_beamvesp xh_beamvesp.c -lm

xh_beamvesp_zcomp:
	$(CC) -Wall -std=gnu99 -o $(BINDIR)/xh_beamvesp_zcomp xh_beamvesp_zcomp.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_bpfilter:
	$(CC) -o $(BINDIR)/xh_bpfilter -g xh_bpfilter.c $(LIBXH) $(LIBSGNL) $(LIBM)

xh_checkorder:
	$(CC) -o $(BINDIR)/xh_checkorder xh_checkorder.c $(LIBXH) $(LIBM) 

xh_cleandata:
	$(CC) -std=c99 -o $(BINDIR)/xh_cleandata xh_cleandata.c $(LIBXH) $(LIBM) $(LIBD)

xh_compare:
	$(CC) -o $(BINDIR)/xh_compare xh_compare.c $(LIBXH) $(LIBM) $(LIBUTL) $(XH_INC)

xh_mult:
	$(CC) -o $(BINDIR)/xh_mult -g xh_mult.c $(LIBXH) $(LIBM) $(XH_INC)

xh_count:
	$(CC) -o $(BINDIR)/xh_count -g xh_count.c $(LIBXH) $(LIBM) $(XH_INC)

xh_copyheader:
	$(CC) -o $(BINDIR)/xh_copyheader -g xh_copyheader.c $(LIBXH) $(LIBM) $(XH_INC)

xh_cuttrace:
	$(CC) -o $(BINDIR)/xh_cuttrace -g xh_cuttrace.c $(LIBXH) $(LIBM) $(LIBTM) 

xh_decim:
	$(CC) -o $(BINDIR)/xh_decim  xh_decim.c $(LIBSGNL) $(LIBXH) $(LIBM) 

xh_detrend:
	$(CC) -o $(BINDIR)/xh_detrend -g xh_detrend.c $(LIBSGNL) $(LIBXH) $(LIBM) 

xh_difftstar:
	$(CC) -o $(BINDIR)/xh_difftstar xh_difftstar.c $(LIBXH) $(LIBSGNL) $(LIBM) $(XH_INC)

xh_disp2vel:
	$(CC) -o $(BINDIR)/xh_disp2vel xh_disp2vel.c $(LIBXH) $(LIBSGNL) $(LIBM) 

xh_dum:
	$(CC) -o $(BINDIR)/xh_dum -g xh_dum.c $(LIBXH) $(LIBM) $(XH_INC)

xh_vel2disp:
	$(CC) -o $(BINDIR)/xh_vel2disp xh_vel2disp.c $(LIBXH) $(LIBSGNL) $(LIBM) $(XH_INC)

xh_epdistcount:
	$(CC) -o $(BINDIR)/xh_epdistcount -g xh_epdistcount.c $(LIBXH) $(LIBD) $(LIBM) $(XH_INC)

xh_envelope:
	$(CC) -o $(BINDIR)/xh_envelope -g xh_envelope.c $(LIBXH) $(LIBSGNL) $(LIBM) 

xh_evtstaloc:
	$(CC) -o $(BINDIR)/xh_evtstaloc -g xh_evtstaloc.c $(LIBXH) $(LIBD) $(LIBM)

xh_findmax:
	$(CC) -o $(BINDIR)/xh_findmax xh_findmax.c $(LIBXH) $(LIBM) $(XH_INC)

xh_flip:
	$(CC) -o $(BINDIR)/xh_flip xh_flip.c $(LIBXH) $(LIBM) $(XH_INC)

xh_fliprcf:
	$(CC) -o $(BINDIR)/xh_fliprcf xh_fliprcf.c $(LIBXH) $(LIBM) $(XH_INC)

xh_grepdepth:
	$(CC) -o $(BINDIR)/xh_grepdepth xh_grepdepth.c $(LIBXH) $(LIBM) $(LIBD) 

xh_grepndata:
	$(CC) -o $(BINDIR)/xh_grepndata xh_grepndata.c $(LIBXH) $(LIBM) $(LIBD) 

xh_grepaz:
	$(CC) -o $(BINDIR)/xh_grepaz xh_grepaz.c $(LIBXH) $(LIBD) $(LIBM)

xh_greploc:
	$(CC) -o $(BINDIR)/xh_greploc xh_greploc.c $(LIBXH) $(LIBD) $(LIBM)

xh_grepdist:
	$(CC) -o $(BINDIR)/xh_grepdist xh_grepdist.c $(LIBXH) $(LIBM) $(LIBD) 

xh_grepchan:
	$(CC) -o $(BINDIR)/xh_grepchan xh_grepchan.c $(LIBXH) $(LIBM) 

xh_grepnetw:
	$(CC) -o $(BINDIR)/xh_grepnetw xh_grepnetw.c $(LIBXH) $(LIBM) 

xh_grepqual:
	$(CC) -o $(BINDIR)/xh_grepqual xh_grepqual.c $(LIBXH) $(LIBM) 

xh_greprecs:
	$(CC) -o $(BINDIR)/xh_greprecs xh_greprecs.c $(LIBXH) $(LIBM) 

xh_grepnetstat:
	$(CC) -o $(BINDIR)/xh_grepnetstat xh_grepnetstat.c $(LIBXH) $(LIBM) 

xh_grepstat:
	$(CC) -o $(BINDIR)/xh_grepstat xh_grepstat.c $(LIBXH) $(LIBM) 

xh_header:
	$(CC) -o $(BINDIR)/xh_header -g xh_header.c $(LIBM) $(LIBXH) 

xh_insheader:
	$(CC) -o $(BINDIR)/xh_insheader xh_insheader.c $(LIBXH) $(LIBM) $(XH_INC)

xh_insBDSN_response:
	$(CC) -o $(BINDIR)/xh_insBDSN_response xh_insBDSN_response.c $(LIBXH) $(LIBM) $(XH_INC)

xh_insCNSN_response:
	$(CC) -o $(BINDIR)/xh_insCNSN_response xh_insCNSN_response.c $(LIBXH) $(LIBM) $(XH_INC)

xh_insNars_response:
	$(CC) -o $(BINDIR)/xh_insNars_response xh_insNars_response.c $(LIBXH) $(LIBM) $(XH_INC)

xh_insinfo:
	$(CC) -o $(BINDIR)/xh_insinfo xh_insinfo.c $(LIBXH) $(LIBM) $(XH_INC)

xh_setqual:
	$(CC) -o $(BINDIR)/xh_setqual xh_setqual.c $(LIBXH) $(LIBM) $(XH_INC)

xh_inslong:
	$(CC) -o $(BINDIR)/xh_inslong xh_inslong.c $(LIBXH) $(LIBM) $(XH_INC)

xh_insdeltat:
	$(CC) -o $(BINDIR)/xh_insdeltat xh_insdeltat.c $(LIBXH) $(LIBM) $(XH_INC)

xh_insqual:
	$(CC) -o $(BINDIR)/xh_insqual xh_insqual.c $(LIBXH) $(LIBM) $(XH_INC)

xh_insRAYtime:
	$(CC) -o $(BINDIR)/xh_insRAYtime xh_insRAYtime.c $(LIBXH) $(LIBD) $(LIBUTL) $(LIBM) $(LIBTM) 

xh_insPtime:
	$(CC) -o $(BINDIR)/xh_insPtime xh_insPtime.c $(LIBXH) $(LIBD) $(LIBUTL) $(LIBM) $(LIBTM) $(XH_INC)

xh_insPPtime:
	$(CC) -o $(BINDIR)/xh_insPPtime xh_insPPtime.c $(LIBXH) $(LIBD) $(LIBUTL) $(LIBM) $(LIBTM) $(XH_INC)

xh_insStime:
	$(CC) -o $(BINDIR)/xh_insStime xh_insStime.c $(LIBXH) $(LIBD) $(LIBUTL) $(LIBM) $(LIBTM) $(XH_INC)

xh_insScStime:
	$(CC) -o $(BINDIR)/xh_insScStime xh_insScStime.c $(LIBXH) $(LIBD) $(LIBM) $(LIBTM) $(XH_INC)

xh_insSStime:
	$(CC) -o $(BINDIR)/xh_insSStime xh_insSStime.c $(LIBXH) $(LIBD) $(LIBM) $(LIBTM) $(XH_INC)

xh_insSKStime:
	$(CC) -o $(BINDIR)/xh_insSKStime xh_insSKStime.c $(LIBXH) $(LIBD) $(LIBM) $(LIBTM) $(XH_INC)

xh_insSKKStime:
	$(CC) -o $(BINDIR)/xh_insSKKStime xh_insSKKStime.c $(LIBXH) $(LIBD) $(LIBM) $(LIBTM) $(XH_INC)

xh_inscmt:
	$(CC) -o $(BINDIR)/xh_inscmt xh_inscmt.c $(LIBXH) $(LIBM) $(LIBTM) $(LIBUTL) 

xh_inspde:
	$(CC) -o $(BINDIR)/xh_inspde xh_inspde.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_inslocc:
	$(CC) -o $(BINDIR)/xh_inslocc xh_inslocc.c $(LIBXH) $(LIBM)

xh_insnetw:
	$(CC) -o $(BINDIR)/xh_insnetw xh_insnetw.c $(LIBXH) $(LIBM) 

xh_inst5:
	$(CC) -o $(BINDIR)/xh_inst5 xh_inst5.c $(LIBXH) $(LIBM) $(XH_INC)

xh_inswavf:
	$(CC) -o $(BINDIR)/xh_inswavf xh_inswavf.c $(LIBXH) $(LIBM) 

xh_longhead:
	$(CC) -o $(BINDIR)/xh_longhead xh_longhead.c $(LIBXH)  $(LIBD) $(LIBPCK) ${INC} $(LIBM)

xh_describe:
	$(CC) -o $(BINDIR)/xh_describe xh_describe.c $(LIBXH) $(LIBD) $(LIBPCK) ${INC} $(LIBSGNL) $(LIBM) 

xh_midpoint:
	$(CC) -o $(BINDIR)/xh_midpoint xh_midpoint.c $(LIBXH) $(LIBD) $(LIBM)

xh_midpointcnt:
	$(CC) -o $(BINDIR)/xh_midpointcnt xh_midpointcnt.c $(LIBXH) $(LIBM) $(LIBD) $(XH_INC)

xh_newfix:
	$(CC) -o $(BINDIR)/xh_newfix xh_newfix.c $(LIBXH) $(LIBM) $(XH_INC)

xh_zneorder:
	$(CC) -o $(BINDIR)/xh_zneorder xh_zneorder.c $(LIBXH) $(LIBM) 

xh_normalize:
	$(CC) -o $(BINDIR)/xh_normalize xh_normalize.c $(LIBXH) $(LIBM) 

xh_onehour:
	$(CC) -o $(BINDIR)/xh_onehour xh_onehour.c $(LIBXH) $(LIBM) $(LIBTM) 

xh_OTeqTS:
	$(CC) -o $(BINDIR)/xh_OTeqTS xh_OTeqTS.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_twohour:
	$(CC) -o $(BINDIR)/xh_twohour xh_twohour.c $(LIBXH) $(LIBM) $(LIBTM) $(XH_INC)

xh_Palignment:
	$(CC) -o $(BINDIR)/xh_Palignment xh_Palignment.c $(LIBXH) $(LIBSGNL) $(LIBM) $(XH_INC)

xh_Ptraveltime:
	$(CC) -o $(BINDIR)/xh_Ptraveltime xh_Ptraveltime.c $(LIBXH) $(LIBSGNL) $(LIBD) $(LIBM) $(XH_INC)

xh_printversion:
	$(CC) -o $(BINDIR)/xh_printversion xh_printversion.c $(LIBXH) $(LIBM) $(LIBD) $(XH_INC)

xh_printmidpoint:
	$(CC) -o $(BINDIR)/xh_printmidpoint xh_printmidpoint.c $(LIBXH) $(LIBD) $(LIBM) 

xh_printresp:
	$(CC) -o $(BINDIR)/xh_printresp xh_printresp.c $(LIBXH) $(LIBM) 

xh_printqual:
	$(CC) -o $(BINDIR)/xh_printqual xh_printqual.c $(LIBXH) $(LIBM) $(XH_INC)

xh_printstat:
	$(CC) -o $(BINDIR)/xh_printstat xh_printstat.c $(LIBXH) $(LIBM) $(XH_INC)

xh_raw2disp:
	$(CC) -o $(BINDIR)/xh_raw2disp xh_raw2disp.c $(LIBXH) $(LIBSGNL) $(LIBM) $(XH_INC)

xh_reorder:
	$(CC) -o $(BINDIR)/xh_reorder xh_reorder.c $(LIBXH) $(LIBSGNL) $(LIBM)

xh_rmv5char_stname:
	$(CC) -o $(BINDIR)/xh_rmv5char_stname xh_rmv5char_stname.c $(LIBXH) $(XH_INC)

xh_rmvPOP:
	$(CC) -o $(BINDIR)/xh_rmvPOP xh_rmvPOP.c $(LIBXH) $(XH_INC)

xh_rmvinstr:
	$(CC) -o $(BINDIR)/xh_rmvinstr xh_rmvinstr.c $(LIBXH) $(LIBSGNL) $(LIBM) $(XH_INC)

xh_raw2vel:
	$(CC) -o $(BINDIR)/xh_raw2vel xh_raw2vel.c $(LIBXH) $(LIBSGNL) $(LIBM) 

xh_recsection:
	$(CC) -o $(BINDIR)/xh_recsection xh_recsection.c $(LIBXH) $(LIBSGNL) $(LIBM) $(LIBD) $(XH_INC)

xh_recsect_PP:
	$(CC) -o $(BINDIR)/xh_recsect_PP xh_recsect_PP.c $(LIBXH) $(LIBM) $(LIBD) $(XH_INC)

xh_recsect_SS:
	$(CC) -o $(BINDIR)/xh_recsect_SS xh_recsect_SS.c $(LIBXH) $(LIBM) $(LIBD) $(XH_INC)

xh_recfunc:
	$(CC) -o $(BINDIR)/xh_recfunc xh_recfunc.c $(LIBXH) $(LIBSGNL) $(LIBNRC) $(LIBTM) $(LIBM) $(XH_INC)

xh_recfunc_zrdecon:
	$(CC) -o $(BINDIR)/xh_recfunc_zrdecon xh_recfunc_zrdecon.c $(LIBXH) $(LIBNRC) $(LIBSGNL) $(LIBTM) $(LIBM) $(XH_INC)

xh_recordheaders:
	$(CC) -o $(BINDIR)/xh_recordheaders xh_recordheaders.c $(LIBXH) $(LIBTM) $(LIBCMT) $(LIBM) $(XH_INC)

xh_rmvchan:
	$(CC) -o $(BINDIR)/xh_rmvchan xh_rmvchan.c $(LIBXH) $(LIBM) 

xh_rmvdist:
	$(CC) -o $(BINDIR)/xh_rmvdist xh_rmvdist.c $(LIBD) $(LIBXH) $(LIBM) 

xh_rmvnetw:
	$(CC) -o $(BINDIR)/xh_rmvnetw xh_rmvnetw.c $(LIBXH) $(LIBM) $(XH_INC)

xh_rmvstat:
	$(CC) -o $(BINDIR)/xh_rmvstat xh_rmvstat.c $(LIBXH) $(LIBM) 

xh_roll:
	$(CC) -o $(BINDIR)/xh_roll xh_roll.c $(LIBXH) $(LIBM)

xh_rotate:
	$(CC) -o $(BINDIR)/xh_rotate xh_rotate.c $(LIBD) $(LIBXH) $(LIBTM) $(LIBM)

xh_synch:
	$(CC) -o $(BINDIR)/xh_synch xh_synch.c $(LIBD) $(LIBXH) $(LIBTM) $(LIBM) 

xh_shorthead:
	$(CC) -o $(BINDIR)/xh_shorthead xh_shorthead.c $(LIBXH) $(LIBD) $(LIBM) 

xh_stationinfo:
	$(CC) -o $(BINDIR)/xh_stationinfo xh_stationinfo.c $(LIBXH) $(XH_INC)

xh_stationlist:
	$(CC) -o $(BINDIR)/xh_stationlist xh_stationlist.c $(LIBXH) $(XH_INC)

xh_stfunction:
	$(CC) -o $(BINDIR)/xh_stfunction xh_stfunction.c $(LIBXH) $(LIBSGNL) $(LIBM) $(XH_INC)

xh_sp_polariz:
	$(CC) -o $(BINDIR)/xh_sp_polariz xh_sp_polariz.c $(LIBM) $(LIBXH) $(LIBD) $(XH_INC)

xh_split:
	$(CC) -o $(BINDIR)/xh_split xh_split.c $(LIBM) $(LIBXH) $(XH_INC)

xh_taper:
	$(CC) -o $(BINDIR)/xh_taper xh_taper.c $(LIBM) $(LIBXH) $(LIBSGNL) 

xh_timeshift:
	$(CC) -o $(BINDIR)/xh_timeshift xh_timeshift.c $(LIBXH) $(LIBSGNL) $(LIBM) $(XH_INC)

xh_vespagram:
	$(CC) -o $(BINDIR)/xh_vespagram xh_vespagram.c $(LIBXH) $(LIBD) $(LIBM) $(LIBSGNL)

xh_wavemax:
	$(CC) -o $(BINDIR)/xh_wavemax xh_wavemax.c $(LIBM) $(LIBXH) $(XH_INC)

xh_weight:
	$(CC) -o $(BINDIR)/xh_weight xh_weight.c $(LIBM) $(LIBD) $(LIBXH) 

xh_weightshow:
	$(CC) -o $(BINDIR)/xh_weightshow xh_weightshow.c $(LIBXH) $(LIBD) $(LIBM) 

xh_testZRT_sequence:
	$(CC) -o $(BINDIR)/xh_testZRT_sequence xh_testZRT_sequence.c $(LIBM) $(LIBXH) $(XH_INC)

xh_zero:
	$(CC) -o $(BINDIR)/xh_zero xh_zero.c $(LIBXH) $(LIBM) 

clean:
	/bin/rm *.o

