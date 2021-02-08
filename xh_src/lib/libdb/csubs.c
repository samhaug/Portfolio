dbexit_()
{	
	extern int trclal_();
#if ( defined(Machine4)  )
	(void)on_exit(trclal_,(char *)0);
#endif
}
