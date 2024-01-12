# 177. Nth Highest Salary
# https://leetcode.com/problems/nth-highest-salary
# tags: database, medium, 30_days_of_pandas

import pandas as pd

def nth_highest_salary(employee: pd.DataFrame, N: int) -> pd.DataFrame:
    col = 'getNthHighestSalary(' + str(N) + ')'

    employee = employee['salary'].unique()
    salaries = pd.Series(employee).sort_values(ascending=False).to_list()
    
    nth_sal = {}

    #check for N values that don't make sense
    if N < 1 or N > len(salaries): 
        nth_sal[col] = None
    else:
        nth_sal[col] = salaries[N-1]
    
    return pd.DataFrame([nth_sal])
