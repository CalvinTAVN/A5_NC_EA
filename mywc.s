/*-----------------------------------------------
//mywc.s
//Author: Calvin Nguyen and Alex Eng
//----------------------------------------------
*/

        .macro enum FALSE = 0, TRUE = 1 
        
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

//Is this allowed?
iInWord:
        .word FALSE

        .section .bss

iChar:
        .skip 4

//-------------------------------------------------

        .section .text

        // Must be a multiple of 16
        // 16 since we aren't using any local variables
        //main uses 8 to start
        .equ MAIN_STACK_BYTECOUNT, 16
        
        .global main

main:

        //prolog
        sub sp, sp, MAIN_STACK_BYTE_COUNT
        str x30, [sp]
        

/*
inside main, while loop underneath


whileLoopStart1:
        if ((! (iChar = getchar()) != EOF)) goto endwhile1 ;

        lCharCount++            ;
        if (! isspace(iChar)) goto else11 ;
                if (! inWord) goto endif21;

                lwordCount++    ;
                iInWord = FALSE ;
                goto endif21       ;

        
else11:  
        if (iInWord) goto endif21;

                iInWord = TRUE  ;
                goto endif21       ;


endif21:
        if(! (iChar == '\n')) goto whileLoopStart1 ;
                1LineCount++    ;
                goto whileLoopStart1 ;


endWhile1:      

        if (! iInWord) goto endif31 ;

                lWordCount++    ;
                goto endif31    ;

endif31:   
        */

whileLoopStart1:
        





        
