# FA22-HackChallenge

App Name: ShareVerse
![ShareVerse](shareverse_backdrop.png)

App Tagline: short one-liner description of your app

A short description of your app (its purpose and features)

A list of how your app addresses each of the requirements

Figma: <https://www.figma.com/file/mRBOzEZ02gwU7uGxa8GhqX/ShareVerse?node-id=0%3A1&t=S0MdtuWBvP1FQTkW-1>

For the backend there are currently 17 routes
GET routes:

1. get all users
2. get user by id
3. get all items
4. get all lend items
5. get all borrow items
6. get a user's lend items
7. get a user's borrow items
8. get a user's saved items

POST routes:

1. create user
2. update user
3. fulfill an item request
4. create an item
5. update an item post
6. save an item to a user's bookmark
7. rate a transaction

DELETE routes:

1. delete user
2. delete item post
 least 4 routes (1 must be GET, 1 must be POST, 1 must be DELETE)

There are 2 tables in the database, 1 for user, 1 for items. They are related by a many-to-many relationship

We implemented images for our items
