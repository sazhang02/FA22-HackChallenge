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
```
There needs to be at least one of either lender_id or borrowing_id. image_url is optional.

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