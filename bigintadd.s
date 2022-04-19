        //
        //bigintadd.s
        //Authors: Calvin Nguyen and Alex Eng
        //

        //No RODATA
        .section .rodata

        //no data since all are parameters, local variables
        .section .data

        //no bss since all are paramters, local variables
        .section .bss

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




        //






        
