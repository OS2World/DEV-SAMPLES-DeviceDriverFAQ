;       Static Name Aliases
;
        TITLE   lio.c
        NAME    lio

        .286
LIOP_TEXT SEGMENT  WORD PUBLIC 'CODE'
LIOP_TEXT ENDS
_DATA   SEGMENT  WORD PUBLIC 'DATA'
_DATA   ENDS
CONST   SEGMENT  WORD PUBLIC 'CONST'
CONST   ENDS
_BSS    SEGMENT  WORD PUBLIC 'BSS'
_BSS    ENDS
DGROUP  GROUP   CONST, _BSS, _DATA
        ASSUME  CS: LIOP_TEXT, DS: DGROUP, SS: DGROUP

LIOP_TEXT      SEGMENT
        ASSUME  CS: LIOP_TEXT

        PUBLIC  _liopl_in

_liopl_in        PROC FAR
        in      al, dx
        ret     
_liopl_in        ENDP

        PUBLIC  _liopl_out

_liopl_out       PROC FAR
        out     dx, al
        ret     

_liopl_out       ENDP
LIOP_TEXT ENDS
END

