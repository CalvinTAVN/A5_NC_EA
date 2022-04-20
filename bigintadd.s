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

        .equ LONGSIZE, 8
        .equ MAX_DIGITS, 32768
        //struct of BigInt_T is 8 bits for long lLength, and 262144 for the long array

        //Must be a multiple of 16
        .equ ADD_STACK_BYTECOUNT, 786496

        //local Variables offset
        .equ ulCarry, 8
        .equ ulSum, 16

        //is long just by itself 8 bits?
        .equ lIndex, 24
        .equ lSumLength, 32

        //Parametric offset , start at 40
        //start of first 3rd struct, the whole size is stored on the heap, x0,
        //x1, and x2, will likely represent the address of a specific struct,
        //which is linked to the heap

        //32768 * 8 = 262144 + 8 = 262152
        .equ oSum, 40

        //40 + 262152 = 262192
        .equ oAddend2, 262192

        //262192 + 262152 = 524344
        .equ oAddend1, 524344
        //goes up to 524344 + 262152 = 786496

        //structural field offsets
        //lLength is defaulted to 0
        .equ lLength, 0
        //so the array aulDigits starts at 8
        .equ aulDigits, 8 
        

        
BigInt_add:

        //prolog
        sub sp, sp, ADD_STACK_BYTECOUNT
        st x30, [sp] //holds return address of BigInt_add I think
        str x0, [sp, oAddend1] 
        str x1, [sp, oAddend2]
        str x2, [sp, oSum]


        //unisgned long ulCarry;
        //unsigned long ulSum;
        //long lIndex;
        //long lSumLength;

        /* Determine the larger length.*/ //note lLength is the first 8 bytes
        // in the struct
        //lSumLength = BigInt_larger(oAddend1->lLength, oAddend2->lLength)
        ldr x0, [sp, oAddend1]
        ldr x1, [sp, oAddend2]
        bl BigInt_Larger
        str x0, [sp, lSumLength]

        /* Clear oSum's array if necessary.*/
        //if (oSum->lLength <= lSumLength) goto add_endif1;
        ldr x0, [sp, oSum]
        ldr x1, [sp, lSumLength]
        cmp x0, x1
        ble add_endif21

        //memset(oSum->aulDigits, 0, MAX_DIGITS * sizeof(unsigned long));
        ldr x0, [sp, oSum]
        add x0, x0, aulDigits //go past 8 bits from lLength to reach array
        mov x1, MAX_DIGITS
        mul x1, x1, LONGSIZE
        bl memset
        
add_endif1:

        /* Perform the addition.*/
        //ulCarry = 0;
        ldr x0, [sp, ulCarry] //not sure if this is necessary, prob not
        mov x0, 0
        str x0, [sp, ulCarry]

        //lIndex = 0;
        ldr x0, [sp, lIndex] //not sure if this is necessary, prob not
        mov x0, 0
        str x0, [sp, lIndex]
        
add_loop1:

        //if (lIndex >= lSumLength) goto add_endloop1;
        ldr x0, [sp, lIndex]
        ldr x1, [sp, lSumLength]
        cmp x0, x1
        bge add_endloop1

        //ulSum = ulCarry;
        ldr x0, [sp, ulCarry]
        str x0, [sp, ulSum]

        //ulCarry = 0;
        mov x0, 0
        str x0, [sp, ulCarry]

        //ulSum += oAddend1->aulDigits[lIndex];
        ldr x0, [sp, ulSum]
        //oAddend1 -> aulDigits[lIndex]
        ldr x1, [sp, oAddend1]
        add x1, x1, aulDigits //adds 8 bits to reach array
        mov x2, lIndex //aulDigits index
        ldr x1, [x1, x2, lsl 3] //left shift 3 to multiply by 8 for long length
        //+=
        add x0, x0, x1
        str x0, [sp, ulSum]

        
        
        
add_endif2:
add_endif3:
add_endloop1:
add_endif5:
add_endif4:     



        
        
        
        







        
        
        

        
        








        


        






        
