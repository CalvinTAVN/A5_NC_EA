        //
        //bigintadd.s
        //Authors: Calvin Nguyen and Alex Eng
        //

        //No RODATA
        .section .rodata

        //no data since all are parameters, local variables
        .section .data

        //only BSS is the BigInt_T struct
        .section .bss

//this is commented out since this file is not the one that creates the struct
//BigInt_T:       .skip 262152

        
        .section .text

        //macro for FALSE and TRUE
        .equ FALSE, 0
        .equ TRUE, 1

        //Returns the larger of lLength1 and lLength2
        //function of BigInt_larger(long lLength1, long lLength2)

        // Must be a Multiple of 16
        .equ LARGER_STACK_BYTECOUNT, 32 
        
        //Local Variables in BigInt_larger stack offset
        .equ lLarger, 8

        //Parameters stack offset
        .equ lLength2, 16
        .equ lLength1, 24


BigInt_larger:

        //prolog
        sub sp, sp, LARGER_STACK_BYTECOUNT
        str x30, [sp]
        str x0, [sp, lLength1]
        str x1, [sp, lLength2]

        //long lLarger

        //if (lLength 1 <= lLength2) goto larger_else;
        ldr x0, [sp, lLength1]
        ldr x1, [sp, lLength2]
        cmp x0, x1
        ble larger_else

        //lLarger = lLength1;
        str x0, [sp, lLarger]

        //goto larger_endif
        b larger_endif
        
larger_else:

        //lLarger = lLength2
        str x1, [sp, lLarger]   
        
larger_endif:

        //epilog and return lLarger
        ldr x0, [sp, lLarger]
        ldr x30, [sp]
        add sp, sp, LARGER_STACK_BYTECOUNT
        ret

        .size gcd, (. - BigInt_larger)





        //------------------------------------

        /*Assign the sum of oAddend1 and oAddend2 to oSum.  oSum should be
        distinct from oAddend1 and oAddend2.  Return 0 (FALSE) if an
        overflow occurred, and 1 (TRUE) otherwise */

        //function of BigInt_add

        //struct of BigInt_T is 8 bits for long lLength, and 262144 for the long array

        //Must be a multiple of 16


        //local Variables offset
        .equ ulCarry, 8
        .equ ulSum, 16

        //is long just by itself 8 bits?
        .equ lIndex, 24
        .equ lSumLength, 32

        //Parametric offset , start at 40
        .equ 
        











        






        
