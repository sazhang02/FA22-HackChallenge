# FA22-HackChallenge

App Name: ShareVerse
![ShareVerse](shareverse_backdrop.png)

App Tagline: A eco-friendly universe of shared goods.

A short description of your app (its purpose and features)
Join the ShareVerse community! Cornell students can login to share items with 
other students around them. 

Do you need a screwdriver to make a quick fix around your room? Or, do you
need to borrow a steamer to make a special meal? Rather, than buy items that you
will only use once, consider borrowing them! Within the ShareVerse community,
students can use in-app credit to borrow items they need for a fixed period of time
from another student on campus.

Similarly, students have the opportunity to lend out their personal items to 
build up credit. Got a tripod stand sitting around your room collecting dust? 
Snap a pic to lend it out and easily build up credit! Using this credit, they can themselves borrow items from other students in times of need. Just by listing items up to be lent,
users can immediately earn credit.

Not only will this save students money, but there are many pros to a community of sharing! Help out the environment and reduce material waste of mass produced items
that are rarely used in ones day-to-day life. Save space in
your temporary living accomodations. Avoid long trips to the go shopping. Build a sense of community with your peers at school!

** Note: Immediate credit from listing items to be lent has yet to be implemented but it is our plan to incentivize users to lend out their items.

## Screens
### Login Page
![Login](login.png)
### Lend Page
![Lend](lend.png)
### Request Page
![Request](request.png)
### Pop-up to Borrow an Item
![Borrow](borrow_request.png)
### Account Page
![Account](account.png)

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
