




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
        if(! (iChar == '\n')) goto endWhile1 ;
                1LineCount++    ;
                goto whileLoopStart1 ;


endWhile1:      

        if (! iInWord) goto endif31 ;

                lWordCount++    ;

endif31:   


*/
