impl Solution {
    pub fn largest_good_integer(num: String) -> String {

        /*  Algorithm
            iterate through the string, starting with the 3 charcter from the left;
            look back to see if charAt(n-2) == charAt(n-1) == charAt(n) and it's larger 
            than current highest digit, if so replace the digit
        */

        let mut highest_digit :Option<u32> = Some(0);
        let mut substring_found: bool = false;

        let char_array: Vec<char> = num.chars().collect();

        for i in 2..num.len() {
            if (char_array[i] == char_array[i-1]) && (char_array[i-1] == char_array[i-2]) {
                
                //parse the character into a integer;
                let examined_digit = char_array[i].to_digit(10);

                if substring_found == false {
                    highest_digit = char_array[i].to_digit(10);
                    substring_found = true;
                } else { 
                    
                    match (examined_digit, highest_digit) {
                        (Some(value1), Some(value2)) => {
                            if value1 > value2 {
                                highest_digit = examined_digit;
                                substring_found = true;
                            }
                        } _ => {
                            //do nothing
                        }
                    }

                }

            }//if
        }

        match highest_digit {
            Some(value) => {
                if substring_found == true {
                    return format!("{}{}{}",value.to_string(),value.to_string(),value.to_string()); 
                } else {
                    return "".to_string();
                }
            } None => {
                return "".to_string()
            }
        }

    }
}