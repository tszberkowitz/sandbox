# explore_badmovies.py

import pandas as pd

fp = r"G:\Other computers\My Computer\Documents\bad_movies.xlsx"

df = pd.read_excel(fp, sheet_name='Main_Sheet')

df.info()
df.head()

