# 2738. Count Occurrences in Text
# https://leetcode.com/problems/count-occurrences-in-text
# tags: pandas, medium


import pandas as pd

def count_occurrences(files: pd.DataFrame) -> pd.DataFrame:
    # Check if 'bull' and 'bear' are standalone words in the 'content' column
    bull_occurrences = files['content'].str.contains(' bull ', case=False).sum()
    bear_occurrences = files['content'].str.contains(' bear ', case=False).sum()

    # Create a new DataFrame with the results
    result_df = pd.DataFrame({
        'word': ['bull', 'bear'],
        'count': [bull_occurrences, bear_occurrences]
    })

    return result_df