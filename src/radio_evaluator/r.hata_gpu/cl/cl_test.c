/* adding two vectors */

#include <stdio.h>
#include <strings.h>
#include <stdcl.h>

#define SIZE 32

int main()
{
    int i;

    CONTEXT* ctx = (stdgpu)? stdgpu : stdcpu;

	/* Query the created context */
    int err = 0;

    struct clstat_info stat_info;

    err = clstat (ctx, &stat_info);

	printf ("clstat exited with err %d\n", err);

    int ndev = clgetndev(ctx);

    struct cldev_info* dev_info
        = (struct cldev_info*)malloc(ndev*sizeof(struct cldev_info));

    err = clgetdevinfo (ctx,dev_info);

	printf ("clgetdevinfo exited with err %d\n", err);

    clfreport_devinfo (stdout,ndev,dev_info);

    free(dev_info);

	/* Start vector sumation */
    void* clh = clopen (ctx, "add_vec.cl",CLLD_NOW);
    cl_kernel k_addvec = clsym (ctx, clh, "addvec_kern", CLLD_NOW);

    float* aa = (float*) clmalloc (ctx,SIZE*sizeof(float),0);
    float* bb = (float*) clmalloc (ctx,SIZE*sizeof(float),0);
    float* cc = (float*) clmalloc (ctx,SIZE*sizeof(float),0);

    for(i=0; i<SIZE; i++)
    {
        aa[i] = 111.0f * i;
        bb[i] = 222.0f * i;
    }

    bzero(cc,SIZE*sizeof(float));

    clndrange_t ndr = clndrange_init1d(0,SIZE,64);

    clmsync (ctx,0,aa,CL_MEM_DEVICE|CL_EVENT_NOWAIT);
    clmsync (ctx,0,bb,CL_MEM_DEVICE|CL_EVENT_NOWAIT);

    clarg_set_global (ctx,k_addvec,0,aa);
    clarg_set_global (ctx,k_addvec,1,bb);
    clarg_set_global (ctx,k_addvec,2,cc);

    clfork (ctx,0,k_addvec,&ndr,CL_EVENT_NOWAIT);

    clmsync (ctx,0,cc,CL_MEM_HOST|CL_EVENT_NOWAIT);

    clwait (ctx,0,CL_MEM_EVENT|CL_KERNEL_EVENT|CL_EVENT_RELEASE);

    for(i=0;i<SIZE;i++) printf("%f %f %f\n",aa[i],bb[i],cc[i]);

    if (aa) clfree(aa);
    if (bb) clfree(bb);
    if (cc) clfree(cc);

    clclose (ctx,clh);
}

