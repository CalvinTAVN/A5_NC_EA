/*--------------------------------------------------------------------*/
/* bigintaddflatten.c                                                 */
/* Author: Bob Dondero                                                */
/*--------------------------------------------------------------------*/

#include "bigint.h"
#include "bigintprivate.h"
#include <string.h>
#include <assert.h>

/* In lieu of a boolean data type. */
enum {FALSE, TRUE};

/*--------------------------------------------------------------------*/

/* Return the larger of lLength1 and lLength2. */

static long BigInt_larger(long lLength1, long lLength2)
{
   long lLarger;
   if (lLength1 <= lLength2) goto larger_else;
   lLarger = lLength1;
   goto larger_endif;

  larger_else:
   lLarger = lLength2;

  larger_endif:

   return lLarger;
      /*
   if (lLength1 > lLength2)
      lLarger = lLength1;
   else
      lLarger = lLength2;
   return lLarger;
   */
}

/*--------------------------------------------------------------------*/

/* Assign the sum of oAddend1 and oAddend2 to oSum.  oSum should be
   distinct from oAddend1 and oAddend2.  Return 0 (FALSE) if an
   overflow occurred, and 1 (TRUE) otherwise. */

int BigInt_add(BigInt_T oAddend1, BigInt_T oAddend2, BigInt_T oSum)
{
   unsigned long ulCarry;
   unsigned long ulSum;
   long lIndex;
   long lSumLength;

   assert(oAddend1 != NULL);
   assert(oAddend2 != NULL);
   assert(oSum != NULL);
   assert(oSum != oAddend1);
   assert(oSum != oAddend2);

   /* Determine the larger length. */
   lSumLength = BigInt_larger(oAddend1->lLength, oAddend2->lLength);

   /* Clear oSum's array if necessary. */
   if (oSum->lLength <= lSumLength) goto add_endif1;
   memset(oSum->aulDigits, 0, MAX_DIGITS * sizeof(unsigned long));
  add_endif1:
   /*
   if (oSum->lLength > lSumLength)
      memset(oSum->aulDigits, 0, MAX_DIGITS * sizeof(unsigned long));
   */


   /* Perform the addition. */
   ulCarry = 0;
   lIndex = 0;

  add_loop1:
   if (lIndex >= lSumLength) goto add_endloop1;

   ulSum = ulCarry;
   ulCarry = 0;

   ulSum += oAddend1->aulDigits[lIndex];
   if (ulSum >= oAddend1->aulDigits[lIndex]) goto add_endif2;
   ulCarry = 1;
  add_endif2:

   ulSum += oAddend2->aulDigits[lIndex];
   if (ulSum >= oAddend2->aulDigits[lIndex]) goto add_endif3;
   ulCarry = 1;
  add_endif3:

   oSum->aulDigits[lIndex] = ulSum;

   lIndex++;
   goto add_loop1;
  add_endloop1:


   /* Check for a carry out of the last "column" of the addition. */
   if (ulCarry != 1) goto add_endif4;

   if (lSumLength != MAX_DIGITS) goto add_endif5;
   return FALSE;
  add_endif5:
   oSum->aulDigits[lSumLength] = 1;
   lSumLength++;
  add_endif4:

   /* Set the length of the sum. */
   oSum->lLength = lSumLength;

   return TRUE;
}
