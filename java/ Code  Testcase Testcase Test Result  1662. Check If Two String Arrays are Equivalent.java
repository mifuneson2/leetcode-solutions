class Solution {
    public boolean arrayStringsAreEqual(String[] word1, String[] word2) {
        int word1ptr = 0, str1ptr = 0, word2ptr = 0, str2ptr = 0;
        boolean word1_next_ok = true, word2_next_ok = true;

        //while not at end of any array
        do {
        
            /* if the character is different, return false
             * each array will always contain at least 1 character, don't
             * don't have to worry about early out of bound case
             */
            if (word1[word1ptr].charAt(str1ptr) != 
                word2[word2ptr].charAt(str2ptr)) {
                return false;   
            }
                


            /* check to see if we can traverse to the next character in string,
             * if you get to the end of a before the both then return false
             * otherwise increment pointers so go to the next character in the string
             */

            //check to see if we can traverse to next char in word1
            //check the character first
            if (str1ptr+1 < word1[word1ptr].length())
                str1ptr++;
            else if (word1ptr+1 < word1.length) {
                word1ptr++;
                str1ptr = 0;
            } else 
                word1_next_ok = false;

            if (str2ptr+1 < word2[word2ptr].length())
                str2ptr++;
            else if (word2ptr+1 < word2.length) {
                word2ptr++;
                str2ptr = 0;
            } else 
                word2_next_ok = false;


            if (word1_next_ok == false && word2_next_ok == false)
                //end of the aggregated string for both, return true
                return true;
            
            //check to see if either of the words can't advance, if so return false
            else if (word1_next_ok == false || word2_next_ok == false)
                return false;            
            

        } while(word1_next_ok == true && word2_next_ok == true);
        //one of the strings could not further advance, not equal string
        return false;
    }
}