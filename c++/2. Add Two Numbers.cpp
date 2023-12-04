/**
 * Definition for singly-linked list.
 * struct ListNode {
 *     int val;
 *     ListNode *next;
 *     ListNode() : val(0), next(nullptr) {}
 *     ListNode(int x) : val(x), next(nullptr) {}
 *     ListNode(int x, ListNode *next) : val(x), next(next) {}
 * };
 */
class Solution {
public:
    ListNode* addTwoNumbers(ListNode* l1, ListNode* l2) {
        int carry = 0;
        ListNode *solution = new ListNode(0); 
        ListNode *returnPtr = solution;

        while(true){
            int x = l1 ? l1 -> val : 0;
            int y = l2 ? l2 -> val : 0;
            int sum = x + y + carry;
            if (sum < 10) {
                solution->val = sum;
                carry = 0;
            } else {
                solution->val = sum %10;
                carry = 1;
            }
            
            //traverse to the next node on the linked lists
            l1 =  l1 ? l1->next : nullptr;
            l2 =  l2 ? l2->next : nullptr;

            if (l1 == NULL && l2 == NULL && carry == 0)
                break;
            else
                solution->next = new ListNode(0);
                solution = solution -> next;

        } //while
        return returnPtr;
    }
};