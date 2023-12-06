impl Solution {
    pub fn merge_alternately(word1: String, word2: String) -> String {
        
        let mut longest_string_len = 0;
        if (word1.len() >= word2.len()) {
            longest_string_len = word1.len();
        } else {
            longest_string_len = word2.len();
        }

        let mut wordVec: Vec<char> = Vec::new();

        let word1_vec: Vec<char> = word1.chars().collect();
        let word2_vec: Vec<char> = word2.chars().collect();

        for i in 0..longest_string_len{

            if i < word1.len() {
                wordVec.push(word1_vec[i]);
            }

            if i < word2.len() {
                wordVec.push(word2_vec[i]);

            }
        }//for

        let combined_string: String = wordVec.into_iter().collect();
        return combined_string;

    }
}