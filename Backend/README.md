# USER ENDPOINTS
## Get all users
**GET** `/api/users/`

Response:
```
<HTTP STATUS CODE 200>
{
  "users": [
      {
          "id": 1,
          "username": "best_app_2022",
          "email": "shareverse@gmail.com",
          "credit": 22,
          "rating": 4.9,
          "profile_image_url": null,
          "lend_items": [],
          "borrow_items": []
      }
  ]
}
```
## Get user by id
**GET** `/api/users/{id}/`

Response:
```
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "username": <STORED USERNAME FOR USER WITH ID {id}>,
  "email": <STORED EMAIL FOR USER WITH ID {id}>,
  "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>
  "rating": <STORED RATING FOR USER WITH ID {id}>
  "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>
  "lend_items": [ <SERIALIZED ITEMS WITHOUT LENDER FIELD>, ... ]
  "borrow_items": [ <SERIALIZED ITEMS WITHOUT BORROWER FIELD>, ... ]
}
```
## Create a user
**POST** `/api/users/`

Request:
```
{
  "username": "best_app_2022",
  "email": "shareverse@gmail.com",
}
```

Response:
```
<HTTP STATUS CODE 201>
{
  "id": <ID>,
  "username": "best_app_2022",
  "email": "shareverse@gmail.com",
  "credit": 20,
  "rating": 5,
  "profile_image_url": null,
  "lend_items": [],
  "borrow_items": []
}
```

## Update user by id
**POST** `/api/users/{id}/`

Request:
```
{
  "username": "new_username_2022",
  "email": "made_a_new_email@gmail.com",
  "profile_image_url": "www.mynewprofileimage.com"
}
```
Note: All three parameters in the request body are optional

Response:
```
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "username": <STORED USERNAME FOR USER WITH ID {id}>,
  "email": "made_a_new_email@gmail.com",
  "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>
  "rating": <STORED RATING FOR USER WITH ID {id}>
  "profile_image_url": "www.mynewprofileimage.com",
  "lend_items": [ <SERIALIZED ITEMS WITHOUT LENDER FIELD>, ... ]
  "borrow_items": [ <SERIALIZED ITEMS WITHOUT BORROWER FIELD>, ... ]
}
```

## Delete user by id
**DELETE** `/api/users/{id}/`

Response:
```
<HTTP STATUS CODE 200>
{
  "id": <ID>,
  "username": <STORED USERNAME FOR USER WITH ID {id}>,
  "email": <STORED EMAIL FOR USER WITH ID {id}>,
  "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>
  "rating": <STORED RATING FOR USER WITH ID {id}>
  "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>
  "lend_items": [ <SERIALIZED ITEMS WITHOUT LENDER FIELD>, ... ]
  "borrow_items": [ <SERIALIZED ITEMS WITHOUT BORROWER FIELD>, ... ]
}
```

# ITEM ENDPOINTS
## Get all items
**GET** `/api/items/`

Response:
```
<HTTP STATUS CODE 200>
{
  "items": [
      {
        "id": 1
        "name": "Umbrella"
        "due_date": "Dec-3-2022",
        "location": "Central",
        "borrower_id": 2,
        "lender_id": 1,
        "credit_value": 5,
        "is_borrow_type": true,
        "is_unfulfilled": true,
        "image_url": "www.umbrella-jpg.com"
      }
  ]
}
```
## Create an item by user id
**POST** `/api/items/{id}/`

Request:
```
{
  "item_name": "Umbrella"
  "due_date": "Dec-3-2022",
  "location": "Central",
  "borrower_id": 2,
  "lender_id": 1,
  "credit_value": 5,
  "is_borrow_type": true,
  "is_unfulfilled": true,
  "image_url": "www.umbrella-jpg.com"
}
```
There needs to be at least one of either lender_id or borrower_id. image_url is optional.

There are two types of posts: borrow and lend. If is_borrow_type is true, then this is a request to borrow an item. Otherwise, this is a offer to lend an item.

due_date can have the following meanings based on the type of post:
- borrow_type: due_date makes the time the user plans to return the item to the lender by.
- lend_type: due_date marks the ending period of time in which the user can lend out their item.

There are two different types of posts: unfulfilled and in progress. 

If is_unfulfilled is true, then this is no one has responded to this post -- no one has accepting this borrow request or no one has took this offer to lend an item. This also means there should be one of lender_id or borrower_id with
a valid id integer and the other should be None.

Otherwise, we know that this post is in progress -- there are two users that are working on this shared "transaction". This also means both lender_id and borrower_id should have a valid id integer. When the transaction is completed, it will be removed from our database (no history).

Response:
```
<HTTP STATUS CODE 201>
{
  "items": [
      {
        "id": 1
        "item_name": "Umbrella"
        "due_date": "Dec-3-2022",
        "location": "Central",
        "borrower_id": 2,
        "lender_id": 1,
        "credit_value": 5,
        "is_borrow_type": true,
        "is_unfulfilled": true,
        "image_url": "www.umbrella-jpg.com"
      }
  ]
}
```