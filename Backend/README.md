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
            "credit": 20,
            "rating": 5,
            "profile_image_url": null,
            "lend_items": [],
            "borrow_items": [],
            "saved_items": []
        }, <SERIALIZED USERS>... 
    ]
}
```

## Get user by id

**GET** `/api/users/{user_id}/`

Response:

```
<HTTP STATUS CODE 200>
{
    "id": <ID>,
    "username": "best_app_2022",
    "email": "shareverse@gmail.com",
    "credit": 20,
    "rating": 5,
    "profile_image_url": null,
    "lend_items": [],
    "borrow_items": [],
    "saved_items": []
}
```

<details>
<summary>Failure Responses</summary>
<br>
```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```
</details>

## Create a user

**POST** `/api/users/`

Request:

```
{
  "username": "best_app_2022",
  "email": "shareverse@gmail.com"
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
    "borrow_items": [],
    "saved_items": []
}
```

<details>
<summary>Failure Responses</summary>
<br>
username or email field not provided

```
<HTTP STATUS CODE 400>
{"error": "please provide a username and email"}
```

email not valid

```
<HTTP STATUS CODE 400>
{"error": "email not valid"}
```
</details>

## Update user by id

**POST** `/api/users/{user_id}/`

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
  {
    "id": <ID>,
    "username": "new_username_2022",
    "email": "made_a_new_email@gmail.com",
    "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>,
    "rating": <STORED RATING FOR USER WITH ID {id}>,
    "profile_image_url": "www.mynewprofileimage.com",
    "lend_items": [ <SERIALIZED ITEMS WITHOUT LENDER FIELD>, ... ],
    "borrow_items": [ <SERIALIZED ITEMS WITHOUT BORROWER FIELD>, ... ],
    "saved_items": [ <SERIALIZED ITEMS>, ... ],
}
```

<details>
<summary>Failure Responses</summary>
<br>
user not found

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```

Note: There is no failure response if the email is invalid, but if the email is invalid, the email field will not be updated.
</details>

## Delete user by id

**DELETE** `/api/users/{user_id}/`

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

<details>
<summary>Failure Responses</summary>
<br>
Failure Responses:<br />
user not found

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```
</details>

# ITEM ENDPOINTS

## Get all items

**GET** `/api/items/`

Response:

```
<HTTP STATUS CODE 200>
{
    "items": [
        {
            "id": 1,
            "item_name": "Umbrella",
            "due_date": "12/01/2022 12",
            "location": "Central Campus",
            "poster_user": {
                "id": 1,
                "username": "best_app_2022",
                "credit": 20,
                "rating": 5,
                "profile_image_url": null
            },
            "fulfiller_user": null,
            "credit_value": 5,
            "is_borrow_type": true,
            "is_unfulfilled": true,
            "image_url": "image.jpg"
        }, <SERIALIZED ITEMS> ...
    ]
}
```

## Create an item by user id

**POST** `/api/items/{user_id}/`

Request:

```
{
    "item_name":"Umbrella",
    "location":"Central Campus",
    "credit_value":5,
    "is_borrow_type":true,
    "image_url":"image.jpg",
    "due_date":"12/1/23 12"
}
```

There are two types of posts: borrow and lend. If is_borrow_type is true, then this is a request to borrow an item. Otherwise, this is a offer to lend an item.

due_date can have the following meanings based on the type of post:

- borrow_type: due_date makes the time the user plans to return the item to the lender by.
- lend_type: due_date marks the ending period of time in which the user can lend out their item.

There are two different types of posts: unfulfilled and in progress.

If is_unfulfilled is true, then this is no one has responded to this post -- no one has accepting this borrow request or no one has took this offer to lend an item.

Otherwise, we know that this post is in progress -- there are two users that are working on this shared "transaction". When the transaction is completed, it will be removed from our database (no history).

Response:

```
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "item_name": "Umbrella",
    "due_date": "12/01/2023 12",
    "location": "Central Campus",
    "poster_user": {
        "id": <user_id>,
        "username": <USER NAME>,
        "credit": <USER CREDIT>,
        "rating": <USER RATING>,
        "profile_image_url": <USER PROFILE IMAGE>
    },
    "fulfiller_user": null,
    "credit_value": 5,
    "is_borrow_type": true,
    "is_unfulfilled": true,
    "image_url": "image.jpg"
}
```

<details>
<summary>Failure Responses</summary>
<br>
user not found

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```

any of item_name, due_date_str, location, credit_value, is_borrow_type is None

```
<HTTP STATUS CODE 400>
{"error": "Missing parameters!"}
```

due_date not in proper format

```
<HTTP STATUS CODE 400>
{"error": "due_date not in proper format! Please enter Month/Day/Year hour[in 24 hour format]. ex '09/19/18 13'"}
```

due_date in the past

```
{"error": "please enter a date in the future"}
```
</details>

## Get all lending items

**GET** `/api/items/lend/`

Response:

```
{
    "lending items": [
        {
            "id": 2,
            "item_name": "Pot",
            "due_date": "01/06/2023 17",
            "location": "North Campus",
            "poster_user": {
                "id": 1,
                "username": "best_app_2022",
                "credit": 20,
                "rating": 5,
                "profile_image_url": null
            },
            "fulfiller_user": null,
            "credit_value": 15,
            "is_borrow_type": false,
            "is_unfulfilled": true,
            "image_url": "image.jpg"
        }, <SERIALIZED ITEMS> ... 
    ]
}
```

## Get all lending items of a user

**GET** `/api/items/lend/<int:user_id>/`

Response:

```
{"lending items": [{"id": 2, "item_name": "Pot"}, <PARTIALLY SERIALIZED ITEMS> ... ]}
```

<details>
<summary>Failure Responses</summary>
<br>
user not found

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```
</details>

## Get all item borrowing request

**GET** `/api/items/borrow/`

Response:

```
{
    "borrow requests": [
        {
            "id": 1,
            "item_name": "Umbrella",
            "due_date": "12/01/2022 12",
            "location": "Central Campus",
            "poster_user": {
                "id": 1,
                "username": "best_app_2022",
                "credit": 20,
                "rating": 5,
                "profile_image_url": null
            },
            "fulfiller_user": null,
            "credit_value": 5,
            "is_borrow_type": true,
            "is_unfulfilled": true,
            "image_url": "image.jpg"
        }, <SERIALIZED ITEMS> ... 
    ]
}
```

## Get all lending items of a user

**GET** `/api/items/borrow/<int:user_id>/`

Response:

```
{"borrow requests": [{"id": 1, "item_name": "Umbrella"}, <PARTIALLY SERIALIZED ITEMS> ...]}
```

<details>
<summary>Failure Responses</summary>
<br>
Failure Responses:<br />
user not found

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```
</details>

## Get all saved items of a user

**GET** `/api/items/saved/<int:user_id>/`

Response:

```
{"saved items": [
        {
            "id": 1, 
            "item_name": "Umbrella"
        }, 
        <PARTIALLY SERIALIZED ITEMS> ...
    ]
}
```

<details>
<summary>Failure Responses</summary>
<br>
user not found

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```
</details>

## Update a post for an item made by a user

**POST** `/api/items/<int:user_id>/<int:item_id>/`

Request:

```
{
    "item_name": "Umbrella",
    "location": "North Campus",
    "credit_value": 10,
    "image_url": "new_image.jpg"
}
```

Response:

```
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "item_name": "Umbrella",
    "due_date": "12/01/2023 12",
    "location": "North Campus",
    "poster_user": {
        "id": <user_id>,
        "username": <USER NAME>,
        "credit": <USER CREDIT>,
        "rating": <USER RATING>,
        "profile_image_url": <USER PROFILE IMAGE>
    },
    "fulfiller_user": null,
    "credit_value": 10,
    "is_borrow_type": true,
    "is_unfulfilled": true,
    "image_url": "new_image.jpg"
}
```

<details>
<summary>Failure Responses</summary>
<br>
The provided user cannot be found.

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```

The provided item cannot be found.

```
<HTTP STATUS CODE 404>
{"error": "item not found"}
```

The user that is trying to update this post is not the original poster

```
<HTTP STATUS CODE 404>
{"error": "user does not have permission to edit this post"}
```


This post has been accepted between two users, so we should not allow any edits to the post after this point.

```
<HTTP STATUS CODE 404>
{"error": "The details of this post cannot be edited when it is being processed."}
```

</details>



## Save a post for an item to a user bookmarks

**POST** `/api/items/saved/<int:user_id>/`

Request:

```
{
    "item_id": <ID>
}
```

Response:

```
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "item_name": "Umbrella",
    "due_date": "12/01/2023 12",
    "location": "North Campus",
    "poster_user": {
        "id": <user_id>,
        "username": <USER NAME>,
        "credit": <USER CREDIT>,
        "rating": <USER RATING>,
        "profile_image_url": <USER PROFILE IMAGE>
    },
    "fulfiller_user": null,
    "credit_value": 10,
    "is_borrow_type": true,
    "is_unfulfilled": true,
    "image_url": "new_image.jpg"
}
```

<details>
<summary>Failure Responses</summary>
<br>
The provided user cannot be found.

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```

The provided item cannot be found.

```
<HTTP STATUS CODE 404>
{"error": "item not found"}
```

The user has already saved this item.
```
<HTTP STATUS CODE 404>
{"error": "item already saved"}
```
</details>



## Delete a post for an item a user 

**DELETE** `/api/items/saved/<int:user_id>/`

Response:

```
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "item_name": "Umbrella",
    "due_date": "12/01/2023 12",
    "location": "North Campus",
    "poster_user": {
        "id": <user_id>,
        "username": <USER NAME>,
        "credit": <USER CREDIT>,
        "rating": <USER RATING>,
        "profile_image_url": <USER PROFILE IMAGE>
    },
    "fulfiller_user": null,
    "credit_value": 10,
    "is_borrow_type": true,
    "is_unfulfilled": true,
    "image_url": "new_image.jpg"
}
```

<details>
<summary>Failure Responses</summary>
<br>
The provided user cannot be found.

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```

The provided item cannot be found.

```
<HTTP STATUS CODE 404>
{"error": "item not found"}
```

The user that wants to delete this post is not the poster.
```
<HTTP STATUS CODE 404>
{"error": "user does not have permission to edit this post"}
```
</details>

