        //---------------------------------------
        //bigintaddoptTest.s
        //Authors: Calvin Nguyen and Alex Eng
        //------------------------------------------

        //No RODATA
        .section .rodata

        //no data since all are parameters, local variables
        .section .data

        //only BSS is the BigInt_T struct
        .section .bss
        
        .section .text

        //macro for FALSE and TRUE
        .equ FALSE, 0
        .equ TRUE, 1

        //Returns the larger of lLength1 and lLength2
        //function of BigInt_larger(long lLength1, long lLength2)

        // Must be a Multiple of 16 //was 32
        .equ LARGER_STACK_BYTECOUNT, 32
        

        //Local Variables in BigInt_larger stack offset
        LLARGER .req x21 //Callee-saved
        
        //Parameters stack offset
        LLENGTH2 .req x20 //Callee-saved
        LLENGTH1 .req x19 //Callee-saved


BigInt_larger:

        //prolog
        sub sp, sp, LARGER_STACK_BYTECOUNT
        str x30, [sp]
        str x19, [sp, 8]
        str x20, [sp, 16]
        str x21, [sp, 24]
        str x19, [sp, 8]
        //store parameters in registers
        mov LLENGTH1, x0 
        mov LLENGTH2, x1
        
        //long lLarger

        //if (lLength 1 <= lLength2) goto larger_else;
        cmp LLENGTH1, LLENGTH2
        ble larger_else

        //lLarger = lLength1;
        mov LLARGER, LLENGTH1
        
        //goto larger_endif
        b larger_endif
        
larger_else:

        //lLarger = lLength2   
        mov LLARGER, LLENGTH2
        
larger_endif:

        //epilog and return lLarger
        mov x0, LLARGER
        ldr x30, [sp]
        ldr x19, [sp, 8]
        ldr x20, [sp, 16]
        ldr x21, [sp, 24]
        add sp, sp, LARGER_STACK_BYTECOUNT
        ret
        
        .size BigInt_larger, (. - BigInt_larger)





        //------------------------------------

        /*Assign the sum of oAddend1 and oAddend2 to oSum.  oSum should be
        distinct from oAddend1 and oAddend2.  Return 0 (FALSE) if an
        overflow occurred, and 1 (TRUE) otherwise */

        //function of BigInt_add

        .equ LONGSIZE, 8
        .equ MAX_DIGITS, 32768

        //Must be a multiple of 16
        .equ ADD_STACK_BYTECOUNT, 96
        
        //local Variables offset

        ULCARRY .req x25
        
        ULSUM .req x24
        
        LINDEX .req x23
        
        LSUMLENGTH .req x22

        
        //Parametric offset 
        OSUM .req x21
       
        OADDEND2 .req x20
        
        OADDEND1 .req x19

        //new Registers to compute +8 to BigInt objects to reach
        //arrays
        OADDENDARRAY1 .req x26
        OADDENDARRAY2 .req x27
        OSUMARRAY .req x28
        
        //structural field offsets
        .equ LLENGTHOFFSET, 0
        //so the array aulDigits starts at 8
        .equ AULDIGITS, 8 
        

        .global BigInt_add
        
BigInt_add:

        //prolog
        sub sp, sp, ADD_STACK_BYTECOUNT
        str x30, [sp] 
        str x19, [sp, 8]
        str x20, [sp, 16]
        str x21, [sp, 24]
        str x22, [sp, 32]
        str x23, [sp, 40]
        str x24, [sp, 48]
        str x25, [sp, 56]
        str x26, [sp, 64]
        str x27, [sp, 72]
        str x28, [sp, 80]

        //Store parameters in registers
        mov OADDEND1, x0
        mov OADDEND2, x1
        mov OSUM, x2

        //store auldigit arrays in registers
        add x3, x0, 8
        mov OADDENDARRAY1, x3
        add x3, x1, 8
        mov OADDENDARRAY2, x3
        add x3, x2, 8
        mov OSUMARRAY, x3
        
        
        
        //unsigned long ulCarry;
        //unsigned long ulSum;
        //long lIndex;
        //long lSumLength;

        /* Determine the larger length.*/ //note lLength is the first 8 bytes
        // in the struct
        //lSumLength = BigInt_larger(oAddend1->lLength, oAddend2->lLength)
        ldr x0, [x0] //length is at the start, so no need to offset
        ldr x1, [x1]
        bl BigInt_larger
        mov LSUMLENGTH, x0
        

        /* Clear oSum's array if necessary.*/
        //if (oSum->lLength <= lSumLength) goto add_endif1;
        ldr x0, [OSUM] //length is at start so no need to offset
        cmp x0, LSUMLENGTH
        ble add_endif1
        
        
        //memset(oSum->aulDigits, 0, MAX_DIGITS * sizeof(unsigned long));
        mov x0, OSUMARRAY
        mov x1, 0
        mov x2, MAX_DIGITS * LONGSIZE
        bl memset
        
add_endif1:

        /* Perform the addition.*/
        //ulCarry = 0;
        mov ULCARRY, 0

        //lIndex = 0;
        mov LINDEX, 0
        
add_loop1:

        //if (lIndex >= lSumLength) goto add_endloop1;
        cmp LINDEX, LSUMLENGTH
        bge add_endloop1

        //ulSum = ulCarry;
        mov ULSUM, ULCARRY
        
        //ulCarry = 0;
        mov ULCARRY, 0
        
        //ulSum += oAddend1->aulDigits[lIndex];
        ldr x0, [OADDENDARRAY1, LINDEX, lsl 3]
        add ULSUM, ULSUM, x0

        //if (ulSum >= oAddend1->aulDigits[lIndex]) goto add_endif2;
        ldr x0, [OADDENDARRAY1, LINDEX, lsl 3]
        cmp ULSUM, x0
        bhs add_endif2
        
        //ulCarry = 1
        mov ULCARRY, 1
        
        
add_endif2:

        //ulSum += oAddend2->aulDigits[lIndex];
        ldr x0, [OADDENDARRAY2, LINDEX, lsl 3]
        add ULSUM, ULSUM, x0
        

        //if (ulSum >= oAddend2->aulDigits[lIndex]) goto add_endif3;
        ldr x1, [OADDENDARRAY2, LINDEX, lsl 3]
        cmp ULSUM, x1
        bhs add_endif3
        
        
        
        //ulCarry = 1
        mov ULCARRY, 1

        
add_endif3:

        //oSum->aulDigits[lIndex] = ulSum
        str ULSUM, [OSUMARRAY, LINDEX, lsl 3]
        
        
        //lIndex++;
        add LINDEX, LINDEX, 1
        
        //goto add_loop1;
        b add_loop1
        
add_endloop1:

        /* Check for a carry out of the last "column" of the addition. */
        //if (ulCarry != 1) goto add_endif4;
        cmp ULCARRY, 1
        bne add_endif4
        
        //if (lSumLength != MAX_DIGITS) goto add_endif5;
        cmp LSUMLENGTH, MAX_DIGITS
        bne add_endif5
        
        //return FALSE and epilog
        mov x0, FALSE
        ldr x30, [sp]
        ldr x19, [sp, 8]
        ldr x20, [sp, 16]
        ldr x21, [sp, 24]
        ldr x22, [sp, 32]
        ldr x23, [sp, 40]
        ldr x24, [sp, 48]
        ldr x25, [sp, 56]
        ldr x26, [sp, 64]
        ldr x27, [sp, 72]
        ldr x28, [sp, 80]
        add sp, sp, ADD_STACK_BYTECOUNT
        ret
        
add_endif5:

        //oSum->aulDigits[lSumLength] = 1;
        mov x1, 1
        str x1, [OSUMARRAY, LSUMLENGTH, lsl 3]
        
        
        //lSumLength++
        add LSUMLENGTH, LSUMLENGTH, 1

add_endif4:     
        //update
        /* Set the length of the sum. */
        //oSum->lLength = lSumLength;
        str LSUMLENGTH, [OSUM]
        
        //return TRUE and epilog
        mov x0, TRUE
        ldr x30, [sp]
        ldr x19, [sp, 8]
        ldr x20, [sp, 16]
        ldr x21, [sp, 24]
        ldr x22, [sp, 32]
        ldr x23, [sp, 40]
        ldr x24, [sp, 48]
        ldr x25, [sp, 56]
        ldr x26, [sp, 64]
        ldr x27, [sp, 72]
        ldr x28, [sp, 80]
        add sp, sp, ADD_STACK_BYTECOUNT
        ret


        .size BigInt_add, (. - BigInt_add)


   
