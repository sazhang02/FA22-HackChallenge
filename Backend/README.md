URL: http://34.86.48.110/
Dockerhub: https://hub.docker.com/repository/docker/sazhang02/shareverse
S3 Bucket for Images: 
# USER ENDPOINTS

## Get all users

**GET** `/api/users/`

Response:

```
<HTTP STATUS CODE 200>
{
    "users": [
        {
            "id": <ID>,
            "username": "best_app_2022",
            "email": "shareverse@cornell.edu",
            "credit": 20,
            "rating": 5,
            "profile_image_url": null,
            "lend_items": [],
            "borrow_items": [],
            "saved_items": [],
            "num_transactions": 0,
            "num_ratings": 1
        },
        {
            "id": <ID>,
            "username": <USERNAME FOR USER WITH ID {id}>,
            "email": <STORED EMAIL FOR USER WITH ID {id}>,
            "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>,
            "rating": <FLOAT FROM 1..5>,
            "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>,
            "lend_items": [<PARTIALLY SERIALIZED ITEMS>],
            "borrow_items": [<PARTIALLY SERIALIZED ITEMS>],
            "saved_items": [<PARTIALLY SERIALIZED ITEMS>],
            "num_transactions": <NUMBER OF TRANSACTIONS THE USER DID>,
            "num_ratings": <NUMBER OF RATINGS ON THIS USER>
        }
        ...
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
    "email": "shareverse@cornell.edu",
    "credit": 20,
    "rating": 5,
    "profile_image_url": null,
    "lend_items": [],
    "borrow_items": [],
    "saved_items": [],
    "num_transactions": 0,
    "num_ratings": 1
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
    "email": "shareverse@cornell.edu",
    "credit": 20,
    "rating": 5,
    "profile_image_url": null,
    "lend_items": [],
    "borrow_items": [],
    "saved_items": [],
    "num_transactions": 0,
    "num_ratings": 1
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

Invalid email address

```
<HTTP STATUS CODE 400>
{"error": "This is not a valid email address."}
```

Not Cornell email address

```
<HTTP STATUS CODE 403>
{"error": "Please use a Cornell email address"}
```

User with email already exists

```
<HTTP STATUS CODE 403>
{"error": "A user with this email already exists. Please use a new email address."}
```

</details>

## Update user by id

**POST** `/api/users/{user_id}/`

Request:

```
{
  "username": "new_username_2022",
  "email": "new_email@gmail.com"
}
```

Note: All parameters in the request body are optional

Response:

```
<HTTP STATUS CODE 200>
{
    "id": <user_id>,
    "username": "new_username_2022",
    "email": "new_email@cornell.edu",
    "credit": 20,
    "rating": 5,
    "profile_image_url": <image_url>,
    "lend_items": [],
    "borrow_items": [],
    "saved_items": [],
    "num_transactions": 0,
    "num_ratings": 1
}
```

<details>
<summary>Failure Responses</summary>
<br>
The user was not found

```
<HTTP STATUS CODE 404>
{"error": "This user was not found."}
```

Note: There is no failure response if the email is invalid, but if the email is invalid, the email field will not be updated.

Invalid email address

```
<HTTP STATUS CODE 400>
{"error": "This is not a valid email address."}
```

Not Cornell email address

```
<HTTP STATUS CODE 403>
{"error": "Please use a Cornell email address"}
```

User with email already exists

```
<HTTP STATUS CODE 403>
{"error": "A user with this email already exists. Please use a new email address."}
```

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
    "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>,
    "lend_items": [ <SERIALIZED ITEMS>, ... ],
    "borrow_items":  [ <SERIALIZED ITEMS>, ... ],
    "saved_items":  [ <SERIALIZED ITEMS>, ... ]
    "num_transactions": <NUMBER OF TRANSACTIONS THE USER DID>,
    "num_ratings": <NUMBER OF RATINGS ON THIS USER>
}
```

<details>
<summary>Failure Responses</summary>
<br>
Failure Responses:<br />
The user was not found

```
<HTTP STATUS CODE 404>
{"error": "This user was not found."}
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
            "credit": 5,
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
   "item_name":"Pot",
    "location":"North Campus",
    "credit":15,
    "is_borrow_type":false,
    "image_data":<BASE64 IMAGE STRING>,
    "due_date":"1/6/23 17"
}
```

There are two types of posts: borrow and lend. If is_borrow_type is true, then this is a request to borrow an item. Otherwise, this is a offer to lend an item.

due_date can have the following meanings based on the type of post:

- borrow_type: due_date makes the time the user plans to return the item to the lender by.
- lend_type: due_date marks the ending period of time in which the user can lend out their item.

There are two different types of posts: unfulfilled and in progress.

If is_unfulfilled is true, then this is no one has responded to this post -- no one has accepting this borrow request or no one has took this offer to lend an item.

Otherwise, we know that this post is in progress -- there are two users that are working on this shared "transaction". In that case, the user will no longer be able to edit the details of the post.

Response:

```
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "item_name": "Pot",
    "due_date": "01/06/2023 17",
    "location": "North Campus",
    "poster_user": {
        "id": <user_id>,
        "email": <STORED EMAIL FOR USER WITH ID {id}>,
        "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>
        "rating": <STORED RATING FOR USER WITH ID {id}>
        "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>,
        "num_transactions": <NUMBER OF TRANSACTIONS THE USER DID>,
        "num_ratings": <NUMBER OF RATINGS ON THIS USER>
    },
    "fulfiller_user": null,
    "credit": 15,
    "is_borrow_type": false,
    "is_unfulfilled": true,
    "image_url": "https://shareverse.s3.us-east-1.amazonaws.com/<IMAGE HASH>.jpg",
    "poster_is_rated": false,
    "fulfiller_is_rated": false
}
```

<details>
<summary>Failure Responses</summary>
<br>
The user was not found

```
<HTTP STATUS CODE 404>
{"error": "This user was not found."}
```

Any of item_name, due_date, location, credit, is_borrow_type, and image_data is None

```
<HTTP STATUS CODE 400>
{"error": "Missing parameters! Please enter item_name, due_date, location, credit, is_borrow_type, and image_data."}
```

Due_date not in proper format

```
<HTTP STATUS CODE 400>
{"error": "The due_date not in the proper format! Please enter Month/Day/Year hour[in 24 hour format]. For example: '09/19/18 13'."}
```

Due_date is in the past

```
{"error": "This date already passed. Please enter a date in the future."}
```

</details>

## Get all lending items

**GET** `/api/items/lend/`

Response:

```
<HTTP STATUS CODE 200>
{
    "lending_items": [
        {
            "id": 1,
            "item_name": "Pot",
            "due_date": "01/06/2023 17",
            "location": "North Campus",
            "poster_user": {
                "id": <user_id>,
                "email": <STORED EMAIL FOR USER WITH ID {id}>,
                "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>
                "rating": <STORED RATING FOR USER WITH ID {id}>
                "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>,
                "num_transactions": <NUMBER OF TRANSACTIONS THE USER DID>,
                "num_ratings": <NUMBER OF RATINGS ON THIS USER>
            },
            "fulfiller_user": null,
            "credit": 15,
            "is_borrow_type": false,
            "is_unfulfilled": true,
            "image_url": "https://shareverse.s3.us-east-1.amazonaws.com/<Image Hash>.jpg",
            "poster_is_rated": false,
            "fulfiller_is_rated": false
            } <SERIALIZED ITEMS> ... 
    ]
}
```

## Get all lending items of a user

**GET** `/api/items/lend/<int:user_id>/`

Response:

```
<HTTP STATUS CODE 200>
{
    "lending items": [
        {"id": 2, "item_name": "Pot"}, 
        <PARTIALLY SERIALIZED ITEMS> ... 
        ]
}
```

<details>
<summary>Failure Responses</summary>
<br>
The user not found

```
<HTTP STATUS CODE 404>
{"error": "This user was not found."}
```

</details>

## Get all item borrowing request

**GET** `/api/items/borrow/`

Response:

```
<HTTP STATUS CODE 200>
{
    "borrow_requests": [
        {
            "id": <ID>,
            "item_name": <ITEM NAME>,
            "due_date": <DUE DATE>,
            "location": <LOCATION>,
            "poster_user": {
                "id": <user_id>,
                "email": <STORED EMAIL FOR USER WITH ID {id}>,
                "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>
                "rating": <STORED RATING FOR USER WITH ID {id}>
                "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>,
                "num_transactions": <NUMBER OF TRANSACTIONS THE USER DID>,
                "num_ratings": <NUMBER OF RATINGS ON THIS USER>
            },
            "fulfiller_user": <FULFILLER ID IF THERE IS ONE,OTHERWISE NULL>,
            "credit": 15,
            "is_borrow_type": true,
            "is_unfulfilled": true,
            "image_url": "https://shareverse.s3.us-east-1.amazonaws.com/<Image Hash>.jpg",
            "poster_is_rated": <BOOL, TRUE IF THERE IS A TRANSACTION RATING ON THE POSTER>,
            "fulfiller_is_rated": <BOOL, TRUE IF THERE IS A TRANSACTION RATING ON THE FULFILLER>
            } <SERIALIZED ITEMS> ... 
    ]
}
```

## Get all lending items of a user

**GET** `/api/items/borrow/<int:user_id>/`

Response:

```
<HTTP STATUS CODE 200>
{
    "borrow requests": [
        {"id": 1, "item_name": "Umbrella"}, 
        <PARTIALLY SERIALIZED ITEMS> ...
    ]
}
```

<details>
<summary>Failure Responses</summary>
<br>
Failure Responses:<br />
The user was not found.

```
<HTTP STATUS CODE 404>
{"error": "user not found"}
```

</details>

## Get all saved items of a user

**GET** `/api/items/saved/<int:user_id>/`

Response:
<HTTP STATUS CODE 200>
```
{
    "saved items": [
        {
            "id": 1, 
            "item_name": "Pot"
        }, 
        <PARTIALLY SERIALIZED ITEMS> ...
    ]
}
```

<details>
<summary>Failure Responses</summary>
<br>
The user was not found

```
<HTTP STATUS CODE 404>
{"error": "This user was not found."}
```

</details>

## Update a post for an item made by a user

**POST** `/api/items/<int:user_id>/<int:item_id>/`
Note: each of the field is optional
Request:

```
{
    "item_name": "Umbrella",
    "location": "Central Campus",
    "credit": 10,
    "due_date": "2/7/24 17"
    "image_data": <BASE64 string>
}
```

Response:

```
<HTTP STATUS CODE 201>
{
    "id": <IF>,
    "item_name": "Umbrella",
    "due_date": "02/07/2024 17",
    "location": "Central Campus",
    "poster_user": {
        "id": <user_id>,
        "email": <STORED EMAIL FOR USER WITH ID {id}>,
        "credit": <STORED CREDIT BALANCE FOR USER WITH ID {id}>
        "rating": <STORED RATING FOR USER WITH ID {id}>
        "profile_image_url": <OPTIONAL STORED PROFILE IMAGE URL FOR USER WITH ID {id}>,
        "num_transactions": <NUMBER OF TRANSACTIONS THE USER DID>,
        "num_ratings": <NUMBER OF RATINGS ON THIS USER>
    },
    "fulfiller_user": null,
    "credit": 10,
    "is_borrow_type": false,
    "is_unfulfilled": true,
    "image_url": "https://shareverse.s3.us-east-1.amazonaws.com/<IMAGE HASH>.jpg",
    "poster_is_rated": false,
    "fulfiller_is_rated": false
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

**POST** `/api/items/saved/<int:user_id>/<int:item_id>`

Response:

```
<HTTP STATUS CODE 201>
{
    "id": <ID>,
    "item_name": "Pot",
    "due_date": "01/06/2023 17",
    "location": "North Campus",
    "poster_user": {
        "id": <user_id>,
        "username": <USER NAME>,
        "credit": <USER CREDIT>,
        "rating": <USER RATING>,
        "profile_image_url": <USER PROFILE IMAGE>
    },
    "fulfiller_user": null,
    "credit": 15,
    "is_borrow_type": true,
    "is_unfulfilled": true,
    "image_url": "https://shareverse.s3.us-east-1.amazonaws.com/AV862OZJRDADGS60.jpg",
    "poster_is_rated": false,
    "fulfiller_is_rated": false
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
    "credit": 10,
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
