# problem from: https://leetcode.com/problems/patients-with-a-condition/?envType=study-plan-v2&envId=30-days-of-pandas&lang=pythondata


import pandas as pd

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    
    return patients[patients['conditions'].str.contains(r'\bDIAB1\w*', regex=True)]
    
