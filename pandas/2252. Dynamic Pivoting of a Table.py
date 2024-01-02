# 2252. Dynamic Pivoting of a Table
# https://leetcode.com/problems/dynamic-pivoting-of-a-table/

import pandas as pd

def dynamic_pivoting_table(products: pd.DataFrame) -> pd.DataFrame:
    pivoted_df = products.pivot_table(index='product_id', columns='store', values='price').reset_index()
    return pivoted_df

