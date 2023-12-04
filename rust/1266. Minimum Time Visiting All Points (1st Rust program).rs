/*

Algorithm

- keep track of coordinates you are currently on
- iterate through each coordinate in the points array
- review destination of target coordinates
- whenever possible go diagonal until you are other on the same X or Y coord as the destination



*/


impl Solution {
    pub fn min_time_to_visit_all_points(points: Vec<Vec<i32>>) -> i32 {

        //set initial coords
        let mut x = points[0][0];
        let mut y = points[0][1];
        let mut movectr = 0;
        let ttlPointsToVisit = points.len();
        let mut pointVisited = 0;

        while (pointVisited < ttlPointsToVisit) {
            /*println!("*** NEW TURN ***");
            println!("current pos: {},{}", x, y);
            println!("target des: {},{}",points[pointVisited][0]
                , points[pointVisited][1] );
            println!("points visited: {}, moves made: {}", pointVisited,movectr);*/


            if (x == points[pointVisited][0]) &&  (y == points[pointVisited][1]) {
                pointVisited = pointVisited + 1;
                continue;
            }

            //move the x & y coords
            movectr = movectr + 1;
            if x < points[pointVisited][0] {
                x = x  + 1;
            } else if x > points[pointVisited][0] {
                x = x - 1;
            }
            
            if y < points[pointVisited][1] {
                y = y + 1;
            } else if y > points[pointVisited][1] {
                y = y - 1;
            }
    
        } //while
        return movectr;

    }
}