impl Solution {
    pub fn total_money(n: i32) -> i32 {

        let mut cum_savings: i32 = 0;
        let mut current_week = 0;
        let mut current_day_of_week = 0;
        
        let mut current_daily_savings = 1; //start at $1
        
        for i in 0..n {
            cum_savings = cum_savings + current_daily_savings;
            current_day_of_week = current_day_of_week + 1;
            current_daily_savings = current_daily_savings + 1;

            //reset to Monday
            if current_day_of_week == 7 {
                current_week = current_week + 1;
                current_day_of_week = 0;
                current_daily_savings = 1 + current_week
            } 

        } //for
        return cum_savings;
    }
}