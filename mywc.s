/*-----------------------------------------------
//mywc.s
//Author: Calvin Nguyen and Alex Eng
//----------------------------------------------
*/

        //.macro enum FALSE = 0, TRUE = 1 
        
        .section .rodata
        
endString:      
        .string "%7ld %7ld %7ld\n"


        .section .data

lLineCount:
        .quad 0
        
lWordCount:
        .quad 0

lCharCount:
        .quad 0

iInWord:
        .word FALSE

        
        .section .bss

iChar:
        .skip 4

//-------------------------------------------------

        .section .text

        //.macro enum FALSE 0, TRUE = 1
        .equ FALSE, 0
        .equ TRUE, 1
        
        // Must be a multiple of 16
        // 16 since we aren't using any local variables
        //main uses 8 to start
        .equ MAIN_STACK_BYTECOUNT, 16

        .equ EOF, -1

        .equ NEWLINE, 10
        
        .global main

main:

        //prolog
        sub sp, sp, MAIN_STACK_BYTECOUNT
        str x30, [sp]
        

whileLoopStart1:

        // if ((! (iChar = getchar()) != EOF)) goto endWhile1
        bl getchar    //sets iChar (x0) to the contents of txt file char
        adr x1, iChar //x1 will be a pointer to iChar
        str w0, [x1]   //Store the char, in x1 which is iChar
        cmp w0, EOF   //Compare EOF to char
        beq endWhile1 //If char is equal to EOF, go to endWhile1

        // lCharCount++
        adr x0, lCharCount //x0 will be a pointer to lCharCount
        ldr w1, [x0]  //load the contents of x0 into w1 which is 0 initially
        add w1, w1, 1 //increase lCharCount by 1
        str w1, [x0] //Store the change in value into lCharCount 

        // if (! isspace(iChar))) goto else11
        adr x0, iChar //x0 will be a pointer to iChar
        ldr w0, [x0] //load the contents of x0 into w0
        bl isspace   //stores the output of isspace into x0
        cmp w0, 0 //compares the contents of isspace to 0
        beq else11

        // if (! iInWord) goto endif21
        adr x0, iInWord //x0 will be a pointer to iInWord
        ldr w0, [x0] //load the contents of iInWord into w0
        cmp w0, TRUE //compares iInWord to 1 (TRUE)
        bne endif21 //if it is not TRUE, go to endif21

        // lwordCount++
        adr x0, lWordCount //x0 will be a pointer to lWordCount
        ldr w1, [x0] //load the contents of lwordCount into w1
        add w1, w1, 1 //increase lWordCount by 1
        str w1, [x0] //store the increased value into x0 (lWordCount)

        // iInWord = FALSE
        adr x0, iInWord //xo will be a pointe to iInWord
        ldr w1, [x0] //load iInWord into w1
        mov w1, FALSE
        str w1, [x0] //set iInWord to FALSE (0)

        // goto endif21
        b endif21   
        


else11:

        // if (iInWord) goto endif21
        adr x0, iInWord // x0 will be a pointer to iInWord
        ldr w0, [x0] //load the contents of iInWord into w0
        cmp w0, TRUE //compares iInWord to 1 (TRUE)
        beq endif21  //if iInWord, go to endif21

        // iInWord = TRUE
        adr x0, iInWord //x0 will be a pointer to iInWord
        ldr w1, [x0] //load the contents of iInWord into w0
        mov w1, TRUE
        str w1, [x0] //set iInWord to TRUE (1)

        // goto endif21
        b endif21
        
endif21:

        //if (! (iChar == '\n')) goto whileLoopStart1
        adr x0, iChar //x0 will be a pointer to iChar
        ldr w0, [x0] //load the contents of x0 into w0
        cmp w0, NEWLINE //compares iChar to EOF
        bne whileLoopStart1 //if iChar != EOF

        // lLineCount++
        adr x0, lLineCount //x0 will be a pointer to lLineCount
        ldr w1, [x0] //load contents of x0 into w1
        add w1, w1, 1 //increase lLineCount by 1
        str w1, [x0] //store the change in x0 (lLineCount)

        //goto whileLoopStart1
        b whileLoopStart1
        
endWhile1:

        //if (! iInWord) goto endif31
        adr x0, iInWord //x0 will be the pointer to iInWord
        ldr w0, [x0] //load the contents of iInWord into w0
        cmp w0, TRUE //compares iInWord to 1 (TRUE)
        bne endif31  //if iInWord is not TRUE

        // lWordCount++
        adr x0, lWordCount //x0 will bea  pointer to lWordCount
        ldr w1, [x0] //load contents of x0 into w1
        add w1, w1, 1 //increase lWordCount by 1
        str w1, [x0] //store the change in x0 (lWordCount)

        //goto endif31
        b endif31
        
endif31:

        //printf("%7ld %7ld %7ld\n", lLineCount, lWordCount, lCharCount);
        adr x0, endString //x0 will be the pointer to endString
        adr x1, lLineCount
        ldr w1, [x1] //loads content of lLineCount into w1
        adr x2, lWordCount
        ldr w2, [x2] //loads contents of lWordCount into w2
        adr x3, lCharCount
        ldr w3, [x3] //loads content of lCharCount into w3
        bl printf

        //Epilog and return 0
        mov w0, 0  //set contents of w0 to 0
        ldr x30, [sp]  //load conents of sp into x30
        add sp, sp, MAIN_STACK_BYTECOUNT //delete the space from stack
        ret


        .size main, (. - main)
        
        
        
      





        
