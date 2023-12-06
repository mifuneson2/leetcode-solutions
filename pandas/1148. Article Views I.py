import pandas as pd

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    df =  views[views["author_id"] == views["viewer_id"]].sort_values(by="author_id")
    df["id"] = df["author_id"]
    return df[["id"]].drop_duplicates()
    