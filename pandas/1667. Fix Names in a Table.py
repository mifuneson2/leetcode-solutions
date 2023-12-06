import pandas as pd

def fix_names(users: pd.DataFrame) -> pd.DataFrame:
    #df = users['user_id']
    users['name_raw'] = users['name']
    users['name'] = users['name_raw'].apply(lambda x: x[0].upper() + x[1:].lower())

    return users[['user_id', 'name']].sort_values(by='user_id')
    