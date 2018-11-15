# HBase

```python
from starbase import Connection
import csv

c = Connection()
ratings = c.table('ratings')
if (ratings.exists()):
    ratings.drop()
ratings.create('rating')

batch = ratings.batch()
if batch:
    print("Batch update... \n")
    with open("../data/ratings.csv", "r") as f:
        reader = csv.reader(f, delimiter=',')
        next(reader)
        for row in reader:
            batch.update(row[0], {'rating': {row[1]: row[2]}})
    
    print("Committing...\n")
    batch.commit(finalize=True)

    print("Get ratings for users...\n")
    print("Ratings for UserID 1: ")
    print(ratings.fetch("1"))

    print("\n")
    print("Ratings for UserID 33: ")
    print(ratings.fetch("33"))
```

> :bug:
>
> hbase start 할 때  `received on PUT method for API: /api/v1/clusters/Sandbox/services/HBASE` -> ambari 창 하나만 냅두고 다 끄니깐 해결,,,,

