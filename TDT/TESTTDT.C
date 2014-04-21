#define INCL_BASE
#include <os2.h>

#include <stdio.h>
#include <conio.h>

#include "tdt.h"

void help (void);

main(int argc, char *argv[], char *envp[])
{
    unsigned long addr;
    unsigned char dest[100];
    unsigned vers;
    int ch, y;

        vers = tdt_version ();
        printf ("TDT version = %x.%x\n", vers >> 8, vers & 0xff);
        help ();
        while (ch = getch ())
        {
                switch (ch)
                {
                    case 'm' :
                        tdt_mem ();
                        break;
                    case 'r' :
                        printf ("Enter Physical address to read in hex - ");
                        scanf ("%lx", &addr);
                        printf ("Reading physical address %lx\n", addr);
                        tdt_getphys (addr, dest, 10);
                        for (y = 0; y < 10; y++)
                                printf ("%02.2x ", dest[y]);
                        printf ("\n");
                        break;
                    case 'x' :
                        exit (0);
                        break;
                    default:
                        help ();
                        break;
                }
        }
}

void help (void)
{
        printf ("Select Function\n"
                "\tm - Memory Display\n"
                "\tr - Read Physical address\n"
                "\tx - eXit this program\n");
}


