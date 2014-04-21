#define INCL_BASE
#include <os2.h>
#include <stdio.h>
#include "tdt.h"

main()
{
    unsigned dest[4], y;

                            // Read 4 words at physical address 40:8
                            // to find which LPTs are installed
        tdt_getphys (0x408L, (UCHAR *)dest, 8);
        for (y = 0; y < 4; y++)
        {
                if (dest[y])
                        printf ("LPT%d Address = %04.4x\n", y, dest[y]);
        }
        return 0;
}

