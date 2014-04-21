;       Static Name Aliases
;
        TITLE   io.c
        NAME    io

        .286
IO_TEXT SEGMENT  WORD PUBLIC 'CODE'
IO_TEXT ENDS
_DATA   SEGMENT  WORD PUBLIC 'DATA'
_DATA   ENDS
CONST   SEGMENT  WORD PUBLIC 'CONST'
CONST   ENDS
_BSS    SEGMENT  WORD PUBLIC 'BSS'
_BSS    ENDS
DGROUP  GROUP   CONST, _BSS, _DATA
        ASSUME  CS: IO_TEXT, DS: DGROUP, SS: DGROUP

EXTRN _liopl_out:far, _liopl_in:far

IO_TEXT      SEGMENT
        ASSUME  CS: IO_TEXT

        PUBLIC  _iopl_in

_iopl_in        PROC FAR
        push    bp
        mov     bp,sp
        xor     ax, ax
;       port = 6
        mov     dx, word ptr [bp+6]
        call    _liopl_in
        pop     bp
        ret
_iopl_in        ENDP

        PUBLIC  _iopl_out

_iopl_out       PROC FAR
        push    bp
        mov     bp,sp
;       port = 6
;       value = 8
        mov     ax, WORD PTR [bp+8] ;value
        mov     dx, WORD PTR [bp+6] ;port

        call    _liopl_out
        pop     bp
        ret

_iopl_out       ENDP
IO_TEXT ENDS
END

