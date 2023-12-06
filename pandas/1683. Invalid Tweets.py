import pandas as pd

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    mask = tweets['content'].str.len() > 15
    return tweets[mask][["tweet_id"]]