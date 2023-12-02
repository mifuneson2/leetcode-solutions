class Solution {
    public int countCharacters(String[] words, String chars) {

        /*
        Algorithm:
        
        Create a reference hashmap for chars, adding all the letters in the string
        chars where each letter is the key and the frequency of the letter in chars is 
        the value.

        Iterate through the array of words
        For each word, 
            - create a similar hashmap of the words' letters are their frequencies
            - check to ensure each letter in the word has enough counts in the reference 
               hashmap.  In any instance it's not, the word is not good and move to the 
               next word.
            - if you get to the end and each letter is good, than its good, add the 
              length of the word to a counter and move to the next word.

        Return the value of the counter

         
        Things you don't need to worry about:
        - all letters are lower case, don't need to worry about capitalization
        - there will always be at least 1 element in the word array
        - only use the 26 letters in the alphabet, don't worry about weirdness in the 
          hashmap key
         
         */

        int charcounter = 0;
        Map<Character, Integer> referenceMap = createCharHash(chars);

        for (String word : words) {
            Map<Character, Integer> examinedWord = createCharHash(word);
            boolean wordOk = true;
            for (Character charKey : examinedWord.keySet()) {
                
                if (referenceMap.getOrDefault(charKey, 0) < examinedWord.get(charKey)) {
                    wordOk = false;
                    break;
                }
            }

            if (wordOk == true)
                charcounter += word.length();

        }

        return charcounter;
    }

    private Map<Character, Integer> createCharHash(String sampleword) {
        Map<Character, Integer> charMap = new HashMap();
        for (Character c : sampleword.toCharArray()) {
            charMap.put(c, charMap.getOrDefault(c, 0)+1);
        }
        return charMap;
    }

}