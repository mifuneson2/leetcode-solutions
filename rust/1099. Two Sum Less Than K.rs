//problem at https://leetcode.com/problems/two-sum-less-than-k/description/

impl Solution {
    pub fn two_sum_less_than_k(nums: Vec<i32>, k: i32) -> i32 {
        let vec_len = nums.len();
        let mut candidate_output = -1;

        if vec_len > 1 {
            for i in 0..vec_len {
                for j in (i+1)..vec_len{
                    let test_sum = nums[i] + nums[j];
                    if test_sum < k && test_sum > candidate_output {
                        candidate_output = test_sum;
                    }
                }
            }
        }//if
        return candidate_output;
    }
}