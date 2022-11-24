# FA22-HackChallenge

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