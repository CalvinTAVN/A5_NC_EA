\0                              //136;0c
        //bigintadd.s
        //Authors: Calvin Nguyen and Alex Eng
        //

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

        // Must be a Multiple of 16
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

        //store parameters in registers
        mov LLENGTH1, x0
        mov LLENGTH2, x1
        
        //long lLarger

        //if (lLength 1 <= lLength2) goto larger_else;
        //ldr x0, [sp, lLength1]
        //ldr x1, [sp, lLength2]
        cmp LLENGTH1, LLENGTH2 
        ble larger_else

        //lLarger = lLength1;
        //str x0, [sp, lLarger]
        mov LLARGER, LLENGTH1
        
        //goto larger_endif
        b larger_endif
        
larger_else:

        //lLarger = lLength2
        //str x1, [sp, lLarger]   
        mov LLARGER, LLENGTH2
        
larger_endif:

        //epilog and return lLarger
        //ldr x0, [sp, lLarger]
        //ldr x30, [sp]
        //add sp, sp, LARGER_STACK_BYTECOUNT
        //ret
        mov x0, LLARGER
        ldr x30, [sp]
        ldr x19, [sp, 8]
        ldr x20, [sp, 16]
        ldr x21, [sp, 24]
        add sp, sp, LARGER_STACKBYTECOUNT
        ret
        
        .size BigInt_larger, (. - BigInt_larger)





        //------------------------------------

        /*Assign the sum of oAddend1 and oAddend2 to oSum.  oSum should be
        distinct from oAddend1 and oAddend2.  Return 0 (FALSE) if an
        overflow occurred, and 1 (TRUE) otherwise */

        //function of BigInt_add

        .equ LONGSIZE, 8
        .equ MAX_DIGITS, 32768
        //struct of BigInt_T is 8 bits for long lLength, and 262144 for the long array

        //Must be a multiple of 16
        //.equ ADD_STACK_BYTECOUNT, 786496
        .equ ADD_STACK_BYTECOUNT, 64
        
        //local Variables offset

        //.equ ulCarry, 8
        ULCARRY .req x25
        
        //.equ ulSum, 16
        ULSUM .req x24
        
        //is long just by itself 8 bits?
        //.equ lIndex, 24
        LINDEX .req x23
        
        //.equ lSumLength, 32
        LSUMLENGTH .req x22
        
        //Parametric offset , start at 40
        //start of first 3rd struct, the whole size is stored on the heap, x0,
        //x1, and x2, will likely represent the address of a specific struct,
        //which is linked to the heap

        //32768 * 8 = 262144 + 8 = 262152
        //.equ oSum, 40
        OSUM .req x21
        
        //40 + 262152 = 262192
        //.equ oAddend2, 262192
        //.equ oAddend2, 48
        OADDEND2 .req x20
        
        //262192 + 262152 = 524344
        //.equ oAddend1, 524344
        //goes up to 524344 + 262152 = 786496
        //.equ oAddend1, 56
        OADDEND1 .req x19
        
        //structural field offsets
        .equ lLengthOffSet, 0
        //so the array aulDigits starts at 8
        .equ aulDigits, 8 
        

        .global BigInt_add
        
BigInt_add:

        //prolog
        sub sp, sp, ADD_STACK_BYTECOUNT
        str x30, [sp] //holds return address of BigInt_add I think
        //str x0, [sp, oAddend1] 
        //str x1, [sp, oAddend2]
        //str x2, [sp, oSum]
        str x19, [sp, 8]
        str x20, [sp, 16]
        str x21, [sp, 24]
        str x22, [sp, 32]
        str x23, [sp, 40]
        str x24, [sp, 48]
        str x25, [sp, 56]

        //Store parameters in registers
        mov OADDEND1, x0
        mov OADDEND2, x1
        MOV OSUM, x2
        
        
        //unsigned long ulCarry;
        //unsigned long ulSum;
        //long lIndex;
        //long lSumLength;

        /* Determine the larger length.*/ //note lLength is the first 8 bytes
        // in the struct
        //lSumLength = BigInt_larger(oAddend1->lLength, oAddend2->lLength)
        //mov x2, lLengthOffSet
        //ldr x0, [sp, oAddend1]
        //ldr x0, [x0, x2, lsl 3]
        //ldr x1, [sp, oAddend2]
        //ldr x1, [x1, x2, lsl 3]
        //bl BigInt_larger
        //str x0, [sp, lSumLength]
        ldr x0, [OADDEND1] //length is at the start, so no need to offset
        ldr x1, [OADDEND2]
        bl BigInt_larger
        mov LSUMLENGTH, x0
        

        /* Clear oSum's array if necessary.*/
        //if (oSum->lLength <= lSumLength) goto add_endif1;
        //ldr x0, [sp, oSum]
        //ldr x0, [x0]
        //ldr x1, [sp, lSumLength]
        //cmp x0, x1
        //ble add_endif1
        ldr x0, [OSUM] //length is at start so no need to offset
        mov x1, LSUMLENGTH
        cmp x0, x1
        ble add_endif1
        
        
        //memset(oSum->aulDigits, 0, MAX_DIGITS * sizeof(unsigned long));
        //ldr x0, [sp, oSum]
        //add x0, x0, aulDigits //go past 8 bits from lLength to reach array
        //mov x1, 0
        //mov x2, MAX_DIGITS
        //MOV x3, 8
        //mul x2, x2, x3
        //bl memset
        ldr x0, [OSUM, AULDIGITS] //offset by 8 bytes to reach array
        mov x1, 0
        mov x2, MAX_DIGITS * 8
        bl memset
        
add_endif1:

        /* Perform the addition.*/
        //ulCarry = 0;
        //ldr x0, [sp, ulCarry] //not sure if this is necessary, prob not
        //mov x0, 0
        //str x0, [sp, ulCarry]
        mov ULCARRY, 0

        //lIndex = 0;
        // ldr x0, [sp, lIndex] //not sure if this is necessary, prob not
        //mov x0, 0
        //str x0, [sp, lIndex]
        mov LINDEX, 0
        
add_loop1:

        //if (lIndex >= lSumLength) goto add_endloop1;
        //ldr x0, [sp, lIndex]
        //ldr x1, [sp, lSumLength]
        //cmp x0, x1
        //bge add_endloop1
        mov x0, LINDEX
        mov x1, LSUMLENGTH
        cmp x0, x1
        bge add_endloop1

        //ulSum = ulCarry;
        //ldr x0, [sp, ulCarry]
        //str x0, [sp, ulSum]
        mov ULSUM, ULCARRY
        
        //ulCarry = 0;
        //mov x0, 0
        //str x0, [sp, ulCarry]
        mov ULCARRY, 0
        
        //ulSum += oAddend1->aulDigits[lIndex];
        //ldr x0, [sp, ulSum]
        //ldr x1, [sp, oAddend1]
        //ldr x2, [sp, lIndex]
        //add x1, x1, aulDigits //adds 8 bits to reach array
        //ldr x1, [x1, x2, lsl 3] //left shift 3 to multiply by 8 for long length
        //add x0, x0, x1
        //str x0, [sp, ulSum]
        mov x0, OADDEND1
        add x0, x0, AULDIGITS
        ldr x0, [x0, LINDEX, lsl 3]
        mov x1, ULSUM
        add x0, x0, x1
        mov ULSUM, x0

        //if (ulSum >= oAddend1->aulDigits[lIndex]) goto add_endif2;
        //ldr x0, [sp, ulSum]
        //ldr x1, [sp, oAddend1]
        //ldr x2, [sp, lIndex]
        //add x1, x1, aulDigits //adds 8 bits to reach array
        //ldr x1, [x1, x2, lsl 3] //left shift 3 to multiply by 8 for long length
        //cmp x0, x1
        //bhs  add_endif2
        mov x0, ULSUM
        mov x1, OADDEND1
        add x1, x1, AULDIGITS
        ldr x1, [x1, LINDEX, lsl 3]
        cmp x0, x1
        bhs add_endif2
        
        //ulCarry = 1
        //ldr x0, [sp, ulCarry] //not sure if this is needed
        //mov x0, 1
        //str x0, [sp, ulCarry]
        mov ULCARRY, 1
        
        
add_endif2:

        //ulSum += oAddend2->aulDigits[lIndex];
        ldr x0, [sp, ulSum]
        ldr x1, [sp, oAddend2]
        ldr x2, [sp, lIndex]
        add x1, x1, aulDigits //adds 8 bits to reach array
        ldr x1, [x1, x2, lsl 3] //left shift 3 to multiply by 8 for long length
        add x0, x0, x1
        str x0, [sp, ulSum]
        

        //if (ulSum >= oAddend2->aulDigits[lIndex]) goto add_endif3;
        ldr x0, [sp, ulSum]
        //oAddend1 -> aulDigits[lIndex]
        ldr x1, [sp, oAddend2]
        ldr x2, [sp, lIndex]
        add x1, x1, aulDigits //adds 8 bits to reach array
        //mov x2, lIndex //aulDigits index
        ldr x1, [x1, x2, lsl 3] //left shift 3 to multiply by 8 for long length
        //if statement
        cmp x0, x1
        //changed since ulSum and aulDigits longs are unsigned
        bhs add_endif3
        
        //ulCarry = 1
        //ldr x0, [sp, ulCarry] //not sure if this is needed
        mov x0, 1
        str x0, [sp, ulCarry]
        
add_endif3:

        //oSum->aulDigits[lIndex] = ulSum
        ldr x2, [sp, ulSum]
        ldr x1, [sp, lIndex]
        ldr x0, [sp, oSum]
        add x0, x0, aulDigits
        //mov x1, lIndex
        str x2, [x0, x1, lsl 3]

        
        //lIndex++;
        ldr x0, [sp, lIndex]
        add x0, x0, 1
        str x0, [sp, lIndex] 

        //goto add_loop1;
        b add_loop1
        
add_endloop1:

        /* Check for a carry out of the last "column" of the addition. */
        //if (ulCarry != 1) goto add_endif4;
        ldr x0, [sp, ulCarry]
        cmp x0, 1
        bne add_endif4

        //if (lSumLength != MAX_DIGITS) goto add_endif5;
        ldr x0, [sp, lSumLength]
        cmp x0, MAX_DIGITS
        bne add_endif5

        //return FALSE and epilog
        mov x0, FALSE
        ldr x30, [sp]
        add sp, sp, ADD_STACK_BYTECOUNT
        ret
        
add_endif5:

        //oSum->aulDigits[lSumLength] = 1;
        ldr x1, [sp, lSumLength]
        ldr x0, [sp, oSum]
        add x0, x0, aulDigits
        mov x2, 1
        str x2, [x0, x1, lsl 3]

        //lSumLength++
        ldr x0, [sp, lSumLength]
        add x0, x0, 1
        str x0, [sp, lSumLength]

add_endif4:     
        //update
        /* Set the length of the sum. */
        //oSum->lLength = lSumLength;
        //ldr x1, [sp, lSumLength]
        //str x1, [sp, oSum] //lLength is the first 8 bits of oSum
        ldr x0, [sp, oSum]
        ldr x1, [sp, lSumLength]
        str x1, [x0]
        
        //return TRUE and epilog
        mov x0, TRUE
        ldr x30, [sp]
        add sp, sp, ADD_STACK_BYTECOUNT
        ret


        .size BigInt_add, (. - BigInt_add)


        
