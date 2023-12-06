import pandas as pd

def find_customers(customers: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    x = customers[~customers['id'].isin(orders['customerId'])]
    return x[["name"]].rename(columns={'name': 'Customers'})