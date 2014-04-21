        ; This device driver does nothing ! It is provided to
        ; illustrate how to generate an assembler map (am) file for S2
        ;
        ; Assemble the driver with the flags
        ;       masm /MX /T /P /L skeleton.asm
        ;
        ; Link using the dev.def definition file
        ;       link /nod /noi /map skeleton, skeleton.sys, , os2, dev;
        ;
        ; Use the AsmMapper utility to generate a control file that s2 can use
        ;       am skeleton.lst > skel.sym
        ;
        ; N.B. The am program recognises Ascii Text strings only if the
        ;      variable name used has a prefix of psz. See the pszEM variable
        ;
        ; Optionally run mapsym to generate symbol file for kernel debug
        ;       mapsym skeleton
        ;
        ; N.B. To date (3/5/91) Microsoft have seen fit not to supply a version
        ; of Mapsym that runs in protected mode. If this is a problem for you
        ; then run mapsym in the DOSBOX and/or contact your friendly FTC
        ; representative
        ;
        ; Modify config.sys so that the skeleton.sys file is installed BEFORE
        ; backdoor.sys - Reboot
        ;
        ; Start S2 in the normal way
        ; Select the device driver option
        ; Select the SKEL1$ driver
        ;     You should now see an in memory disassembly of SKELETON.SYS
        ; Type F4 for the file options
        ; Select option 2 - INPUT file control information
        ; Enter the name of the control file skel.sym
        ;
        ; If you want to use this control file again
        ; Type F4 for the file options
        ; Select option 3 - OUTPUT file control information
        ;
        ; The control file will then be used automatically
        ;
          .286p                     ;Tell the assembler to recognize and
                                    ; assemble 80286 instructions


include  devhlp.inc


data SEGMENT word public 'data'

Dev_Header        equ  $
ptr_to_nxt_hdr    dw   0ffffh
                  dw   -1
device_attr       dw   088c0h
                                    ;Device level OS/2
                                    ;Indicate char device
offst             dw   dcode:STRATEGY
reserved          dw   -1

named             db   'SKEL1$  '   ;Name of the device
reserved_words    dw   4  dup (0)    ;Reserved words

busy              equ   0200h       ;Word representing the code for BUSY
done              equ   0100h       ;Word representing the code for DONE
error             equ   8000h       ;Word indicating error
general_failure   equ   000ch       ;General failure error code
unknown_command   equ   0003h       ;Unknown command error code


PktMax            equ   18          ;Maximum size of packet
;
;Structure of a request packet
;
Packet            struc
PktLen            db      ?         ; Length in bytes of packet
PktUnit           db      ?         ; Subunit number of block device
PktCmd            db      ?         ; Command code
PktStatus         dw      ?         ; Status word
PktDOSLink        dd      ?         ; Reserved
PktDevLink        dd      ?         ; Device multiple-request link
PktData           db      PktMax dup (?)
                                    ;Data pertaining to specific packet
Packet            ends
;
;Pointer constants for the request packets
;
InitpEnd          equ   dword ptr PktData+1
                                    ;Pointer to free mem after dev
IOpData           equ   dword ptr PktData+1
                                    ;Transfer address
IOcount           equ   word ptr PktData+5
                                    ;Count of bytes/sectors

GIOCategory       equ   byte  ptr PktData
GIOFunction       equ   byte  ptr PktData+1
GIOParaPack       equ   dword ptr PktData+2
GIODataPack       equ   dword ptr PktData+6

PUBLIC device_hlp

device_hlp        dd   ?            ;Holds address of the DevHlp functions

max_in_table     equ   21
dispatch_table   dw    INIT
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    IGNORE       ;Command code 8 calls WRITE Subroutine
                 dw    BAD
                 dw    IGNORE       ;Command code 10 calls STATUS Subroutine
                 dw    IGNORE       ;Command code 11 calls FLUSH Subroutine
                 dw    BAD
                 dw    IGNORE       ;Command code 13 calls OPEN Subroutine
                 dw    IGNORE       ;Command code 14 calls CLOSE Subroutine
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    BAD
                 dw    IGNORE       ;Command code 20 calls DEINSTALL Subroutine

pszEM           db      'This marks the end of the Skeleton device driver'

END_OF_DATA     equ  $

Signonmsg       db      'Skeleton Device', 0ah, 0dh
Signonlen       = $ - Signonmsg
Actual          dw      0

data ENDS


dcode     SEGMENT  word public 'code'      ;Define code segment
          assume cs:dcode,ds:data

extrn DOSWRITE:far

STRATEGY PROC FAR

                                    ;Command code is moved into al
          mov     al,byte ptr es:[bx].PktCmd
          cmp     al,max_in_table   ;If index larger than those supported
          ja      UNSUPPORTED       ; jump to indicate that the command is
                                    ; unsupported

          cbw                       ;Byte in al is converted to word
          mov     di,ax             ;It is then moved to di
          shl     di,1              ;Converted to an index

          push    es                ;Save the pointers to the request packet
          push    bx
          call    word ptr dispatch_table[di]
          pop     bx                ;Restore the pointers to the request packet
          pop     es

          or   es:[bx].PktStatus,done
          ret

UNSUPPORTED:
          call    BAD               ;Call BAD
          ret
STRATEGY ENDP


IGNORE PROC NEAR
          int   3
          ret
IGNORE ENDP


BAD PROC NEAR
          or es:[bx].PktStatus,error + unknown_command
          ret
BAD ENDP


SIGNAL_ERROR PROC NEAR
          or es:[bx].PktStatus,error or general_failure ;Unknown command
          ret
SIGNAL_ERROR ENDP


END_OF_CODE  equ $

INIT PROC NEAR

              ; set device_hlp to contain the
              ; address of the helper services

          mov     ax,word ptr es:[bx].InitpEnd
          mov     word ptr device_hlp,ax
          mov     ax,word ptr es:[bx].InitpEnd+2
          mov     word ptr device_hlp+2,ax

              ; Place the addresses of the end of code segment  and the
              ; end of the data segment into the request header

          lea     ax,END_OF_CODE
          mov     word ptr es:[bx].InitpEnd,ax
          lea     ax,END_OF_DATA
          mov     word ptr es:[bx].InitpEnd+2,ax

              ; Output the sign on message to the screen
              ; DOSWRITE (handle, address, length, actual_bytes_written);

          push    1               ; stdout device handle
          mov     ax, offset Signonmsg
          push    ds
          push    ax
          mov     ax, Signonlen
          push    ax
          mov     ax, offset Actual
          push    ds
          push    ax
          call    DOSWRITE

          ret

INIT ENDP
dcode ENDS

     END

