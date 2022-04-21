/*--------------------------------------------------------------------*/
/* randomchar.c                                                       */
/* Author: Calvin Nguyen and Alex Eng                                 */
/*--------------------------------------------------------------------*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main(void)
{   
    int i, j, x;

    for (i = 0; i < 500; i++)
    {
        for (j = 0; j < 49; j++)
        {
            x = (rand() % 97) + 30;
            if ((x >= 32) && (x <=126))
            {
                putchar(x);
            }
            else
            {
                putchar(x - 21);
            }
        }
        putchar(10);
    }
    return 0;
}