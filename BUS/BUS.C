//
// This program demonstrates how to query the IGEIO$ device drivers
// current mode and also how to set it to a different mode of operation
//

#define INCL_DOS
#include <os2.h>
#include <stdio.h>
#include <string.h>
#include <process.h>

#define  CFG_CATEGORY      0x80         // category code
#define  CFG_MISC_QUERY    0x60         // function code
                                        // set params to NULL
                                        // allow 4 bytes in buffer for
                                        // return value of ULONG

#define CFG_ISA_BUS    0                // possible return values
#define CFG_MCA_BUS    1                // placed in data buffer
#define CFG_EISA_BUS   2

unsigned main (int argc, char **argv)
{
    HFILE  handle;
    USHORT action, rc;
    ULONG cmd, result;

        rc = DosOpen ((PSZ)"TESTCFG$", &handle, &action, 0L, 0,
                    OPEN_ACTION_OPEN_IF_EXISTS,
                    0x42, 0L);
        if (rc)
        {
                printf ("Error %d opening Testcfg$\n", rc);
                exit (1);
        }
        result = cmd = 0L;
        rc = DosDevIOCtl ((PVOID)&cmd, (PVOID)&result, CFG_MISC_QUERY,
                        CFG_CATEGORY, handle);
        if (rc)
        {
                printf ("Error %d using ioctl on Testcfg$\n", rc);
                exit (1);
        }
        switch (cmd)
        {
         case CFG_ISA_BUS :
            printf ("ISA Bus machine\n");
            break;
         case CFG_MCA_BUS :
            printf ("MCA Bus machine\n");
            break;
         case CFG_EISA_BUS :
            printf ("EISA Bus machine\n");
            break;
         default:
           printf ("Unknown Bus type %ld\n", result);
           break;
        }

        DosClose (handle);

        return 0;
}

