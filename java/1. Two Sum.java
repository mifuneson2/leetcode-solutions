class Solution {
    public int[] twoSum(int[] nums, int target) {
        //brute force method
        for (int x = 0; x < nums.length; x++) {
            for (int y = 0; y < nums.length; y++) {
                if ((x != y) && (nums[x] + nums[y] == target)) {
                    return new int[] {x,y}; 
                } //if
            } //for
        } //for   
        return new int[] {0,0}; //this should never be returned, there is exactly 1 solution
    } //int[]
}//class