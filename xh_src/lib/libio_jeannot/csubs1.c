#define KERNEL =YES
#include <stdio.h>
#include <sys/proc.h>
#include <fcntl.h>
#include <kvm.h>
#include <vm/seg_vn.h>

char **argv;
int argc;
kvm_t *kd;
struct proc *prc, *prcnull=0;


main(argv,argc)
{
ckvmopen_();
}

ckvmopen_()
{
	int setp, nn=0;
	printf("masterprocp %d %d %d\n",(int)procNPROC,nproc,qs[0].ph_link);
	kd = kvm_open(0, 0, 0, O_RDONLY, "Error");
	printf("kvm_open returned: %d\n",(unsigned)kd);
	setp=kvm_setproc(kd);
	printf("kvm_setproc returned: %d\n",setp);
	for ( prc=(struct proc *)1 ;  prc != prcnull  ;)
	{
		printf("Calling kvm_nextproc\n");
		prc=kvm_nextproc(kd);
		printf("kvm_nextproc returned: %d\n",(int)prc);
	}
	printf("masterprocp %d %d %d\n",(int)procNPROC,nproc,qs[0].ph_link);

}
