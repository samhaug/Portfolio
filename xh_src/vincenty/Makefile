
CFLAGS= -g -Wall -O3
LDLIBS=
CC= gcc
BIN=../bin
LIBDIR=/home/samhaug/src/xh_src/lib
                     
all: test_speed ascii_rotate_ne_rt ascii_rotate_rt_ne ascii_rotate_nez_lqt \
     az_gcarc az_spread gc_spread vincenty_direct vincenty_direct_file \
     vincenty_inverse vincenty_inverse_file vincenty_direct_sphere \
     vincenty_inverse_sphere connect_rays incoming_ray_coords \
     source_stat_midpoint bin_midpoint strike_dip_rake_to_CMTSOLUTION

test_speed: vincenty.c test_speed.c
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

ascii_rotate_ne_rt: 
	$(CC) $(CFLAGS) $@.c -lm -o $(BIN)/$@

ascii_rotate_rt_ne: 
	$(CC) $(CFLAGS) $@.c -lm -o $(BIN)/$@

ascii_rotate_nez_lqt: 
	$(CC) $(CFLAGS) $@.c -lm -o $(BIN)/$@

az_gcarc: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

az_spread: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

gc_spread: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

vincenty_direct: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

vincenty_direct_file: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

vincenty_inverse: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

vincenty_inverse_file: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

vincenty_direct_sphere: 
	$(CC) $(CFLAGS) vincenty_sphere.c $@.c -lm -o $(BIN)/$@

vincenty_inverse_sphere: 
	$(CC) $(CFLAGS) vincenty_sphere.c $@.c -lm -o $(BIN)/$@

connect_rays: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

incoming_ray_coords: 
	$(CC) $(CFLAGS) vincenty.c $@.c -lm -o $(BIN)/$@

source_stat_midpoint: 
	$(CC) $(CFLAGS) $(LIBDIR)/libdist.a vincenty.c $@.c -lm -o $(BIN)/$@

bin_midpoint: 
	$(CC) $(CFLAGS) $(LIBDIR)/libdist.a vincenty.c $@.c -lm -o $(BIN)/$@

strike_dip_rake_to_CMTSOLUTION: 
	$(CC) $(CFLAGS) $@.c -lm -o $(BIN)/$@


