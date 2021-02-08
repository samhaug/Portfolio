/*
#-- Ztable
#--
#-- used in my_src/TurningDepths/mkZbin.c
#--
#-- Version 0.95 -- February 2003
#--
#-- Jeroen Ritsema
#-- Departement de Sismologie
#-- IPG Paris
*/

#define Z_VERSION	0.95
#define Z_HDRSIZE	64
#define I_12345678	12345678
#define F_12345678	12345678.0

#define NPTS		180
#define CHARSIZE	20
#define NEXTRAS		8

typedef struct {
	float version;	// format version #
	int   nhdr;	// # of bytes in header
	float depth;	// source depth
    int   ndist;	// number of distances
	char  model[CHARSIZE];	// model name
	char  phase[CHARSIZE];	// phase name

	char  padding[NEXTRAS];	// padding the header up to X_HDRSIZE
   } Zhed;
