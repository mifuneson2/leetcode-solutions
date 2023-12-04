/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode() {}
 *     ListNode(int val) { this.val = val; }
 *     ListNode(int val, ListNode next) { this.val = val; this.next = next; }
 * }
 */
class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode solution = new ListNode(0);
        ListNode solutionStart = solution;
        int carry = 0;

        while (true) {
            int x;
            if (l1 != null)
                x= l1.val;
            else
                x = 0;

            int y;
            if (l2 != null )
                y=l2.val;
            else
                y = 0;

            if ((x + y + carry) < 10) {
                solution.val = x + y + carry;
                carry = 0;
            } else { 
                solution.val = (x + y + carry) % 10;
                carry = 1;
            }

            //move pointers to the next segment
            if (l1 != null)
                l1 = l1.next;

            if (l2 != null)
                l2 = l2.next;

            if ((l1 == null) && (l2 == null) && (carry == 0)) {
                //no more elements left to add
                break;
            } else {
                solution.next = new ListNode(0);
                solution = solution.next; //traverse to next segment
            }

        
        } //while 
        return solutionStart; //return reference to the first node   
    }
}