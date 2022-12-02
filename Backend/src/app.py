from re import T, fullmatch
from db import Item, User, Asset, db
from flask import Flask, request
import json 
from datetime import datetime


app = Flask(__name__)
db_filename = "shareverse.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True
email_regex = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'
def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

db.init_app(app)
with app.app_context():
    db.create_all()

# Different response text
user_not_found = "This user was not found."
item_not_found = "This item was not found."

# --------------------------------------------------------------
# ----------------------- IMAGE REQUESTS ----------------------
# --------------------------------------------------------------
def upload(image_data):
    """
    Endpoint for uploading an image to AWS given its base64 form,
    then storing/returning the URL of that image
    """
    if image_data is None:
        return failure_response("No base64 image found",)
    asset = Asset(image_data = image_data)
    db.session.add(asset)
    db.session.commit()
    return asset.serialize().get("url")

# --------------------------------------------------------------
# --------------------------------------------------------------
# ----------------------- USER ENDPOINTS -----------------------
# --------------------------------------------------------------
# --------------------------------------------------------------

# --------------------------------------------------------------
# ------------------------- GET REQUESTS -----------------------
# --------------------------------------------------------------
@app.route("/")
def greet_user():
    """
    Endpoint to greet users
    """
    return "Welcome to ShareVerse!"

@app.route("/api/users/")
def get_all_users():
    """
    Endpoint for getting all users
    """
    users = [user.serialize() for user in User.query.all()]
    return success_response({"users": users})


@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    """
    get a specific user by id user_id
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response(user_not_found,404)
    return success_response(user.serialize())

# --------------------------------------------------------------
# ------------------------ POST REQUESTS -----------------------
# --------------------------------------------------------------

def validate_email(email):
    """
    Returns True if the email is valid and False otherwise. An email is valid
    if it follows an email format (e.g. email_name@domain) and the domain is @cornell.edu.

    Also, returns a failure response respectively.
    """
    if not fullmatch(email_regex, email):
        return False, failure_response("This is not a valid email address.", 400)

    if email[email.rindex('@'):] != "@cornell.edu":
        return False, failure_response("Please use a Cornell email address", 403)

    if (User.query.filter_by(email= email).first() != None):
        return False, failure_response("A user with this email already exists. Please use a new email address.", 403)

    return True, None


@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    create a user
    """
    body = json.loads(request.data)
    username=body.get('username')
    email=body.get('email')
    if username is None or email is None:
        return failure_response("Please provide a username and email.",400)

    valid_email, failure_response = validate_email(email)
    if not valid_email:
        return failure_response

    new_user = User(
        username= username,
        email=email,
        credit=20,
        rating=5,
        profile_image_url=None,
        num_transactions=0,
        num_ratings=1 # default rating 5 leeway to start them off
        )

    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)


@app.route("/api/users/<int:user_id>/", methods = ['POST'])
def update_user(user_id):
    """
    update an user with id user_id
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response(user_not_found,404)
    body = json.loads(request.data)

    username = body.get("username")
    email = body.get("email")
    image=body.get("profile_image_url")

    if email is not None:
        valid_email, failure_response = validate_email(email)
        if not valid_email:
            return failure_response
        user.email = email
    
    if username is not None:
        user.username = username
        
    if image is not None:
        user.profile_image_url = image
    db.session.commit()
    return success_response(user.serialize(), 201)



# --------------------------------------------------------------
# ------------------------- DELETE REQUESTS -----------------------
# --------------------------------------------------------------

@app.route("/api/users/<int:user_id>/", methods = ['DELETE'])
def delete_user(user_id):
    """
    delete a user
    """
    user=User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response(user_not_found, 404)
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize(), 202)

# --------------------------------------------------------------
# --------------------------------------------------------------
# ----------------------- ITEM ENDPOINTS -----------------------
# --------------------------------------------------------------
# --------------------------------------------------------------



# --------------------------------------------------------------
# ------------------------ GET REQUESTS ------------------------
# --------------------------------------------------------------

# --------------------- ITEM INFORMATION------------------------
@app.route("/api/items/")
def get_all_items():
    """
    Endpoint for getting all items
    """
    items = [item.serialize() for item in Item.query.all()]
    return success_response({"items": items})


@app.route("/api/items/<int:item_id>/") 
def get_item(item_id):
    """
    Endpoint for getting an item by the item's item_id
    """
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response(item_not_found,404)
    return success_response(item.serialize())

# --------------------- BORROWED ITEM INFORMATION------------------
@app.route("/api/items/borrow/")
def get_all_borrowing_items():
    """
    get all the borrowing items in database
    """
    lst = [item.serialize() for item in Item.query.all() if item.is_borrow_type]
    return success_response({"borrow requests":lst})

@app.route("/api/items/borrow/<int:user_id>/")
def get_user_borrowing_items(user_id):
    """
    get all of the user's borrowing items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response(user_not_found,404)
    items = [item.serialize() for item in user.borrow_items]
    return success_response({"borrow requests":items})

# --------------------- LENT ITEM INFORMATION----------------------
@app.route("/api/items/lend/")
def get_all_lending_items():
    """
    get all the lending items in database
    """
    lst = [item.serialize() for item in Item.query.all() if not item.is_borrow_type]
    return success_response({"lending_items":lst})


@app.route("/api/items/lend/<int:user_id>/")
def get_user_lending_items(user_id):
    """
    get all of the user's lending items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response(user_not_found,404)
    items = [item.serialize() for item in user.lend_items]
    return success_response({"lending_items": items})

# --------------------- SAVED ITEM INFORMATION----------------------

@app.route("/api/items/saved/<int:user_id>/")
def get_user_saved_items(user_id):
    """
    get all of the user's saved items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response(user_not_found, 404)
    saved_items = [s.serialize for s in user.saved_items]
    return success_response({"saved items":saved_items})

# --------------------------------------------------------------
# ----------------------- POST REQUESTS ------------------------
# --------------------------------------------------------------

@app.route("/api/items/<int:user_id>/", methods=["POST"])
def create_item(user_id):
    """
    Endpoint for creating an item by user_id
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response(user_not_found,404)
    body = json.loads(request.data)

    # Process request body if the user IS found
    item_name = body.get("item_name")
    due_date_str = body.get("due_date")
    location = body.get("location")
    credit = body.get("credit")
    is_borrow_type = body.get("is_borrow_type")
    image_data = body.get("image_data")

    # Check if request input is valid
    if (
        item_name is None or 
        due_date_str is None or 
        location is None or
        credit is None or
        is_borrow_type is None or
        image_data is None):
        return failure_response("Missing parameters!", 400)
    try:
        due_date = datetime.strptime(due_date_str, '%m/%d/%y %H')
        if due_date < datetime.now():
            return failure_response("please enter a date in the future", 400)
    except:
        return failure_response("due_date not in proper format! Please enter Month/Day/Year hour[in 24 hour format]. ex '09/19/18 13'", 400)
    # Create an item
    new_item = Item(
        item_name = item_name,
        due_date = due_date,
        location = location,
        poster_id = user_id,
        credit = credit,
        is_borrow_type = is_borrow_type,
        image_url = upload(image_data),
        is_unfulfilled = True,
        poster_is_rated = False,
        fulfiller_is_rated = False
    )
    # Add item to the user's lending/borrowing list
    if is_borrow_type == True:
        # print("<><><><><><><><><>><<><<><<><><><><>><",user.items)
        # print("<><><><><><><><><>><<><<><<><><><><>><type type type type type",type(user.items))
        user.borrow_items.append(new_item)
        print("<><><><><><><><><>><<><<><<><><><><>><",user.borrow_items)
    else: 
        user.lend_items.append(new_item)
        print("asdasd<><><><><><><><><>><<><<><<><><><><>><",user.lend_items)

    # Add item to Item database
    db.session.add(new_item)
    db.session.commit()
    # print(User.query.filter_by(id= user_id).first().items)
    return success_response(new_item.serialize(), 201)


@app.route("/api/items/<int:user_id>/<int:item_id>/", methods = ['POST'])
def update_item(user_id, item_id):
    """
    update an item with id item_id
    """
   
    body = json.loads(request.data)
    item = Item.query.filter_by(id= item_id).first()

    if item is None:
        return failure_response(item_not_found, 404)
    body = json.loads(request.data)

    if item.poster_id != user_id:
        return failure_response("user does not have permission to edit this post",403)

    if not item.is_unfulfilled:
        # This post has been accepted between two users, so we should not allow 
        # any edits to the post after this point
        return failure_response("The details of this post cannot be edited when it is being processed.",403)

    iname = body.get("item_name")
    # due_date = due_date,
    location = body.get("location")

    credit = body.get("credit")
    image_data = body.get("image_data")

    if iname is not None:
        item.item_name = iname
    if location is not None:
        item.location =location
    if credit is not None:
        item.credit = credit
    if image_data is not None:
        item.url = upload(image_data)

    db.session.commit()
    return success_response(item.serialize(), 201)

@app.route("/api/items/saved/<int:user_id>/<int:item_id>/", methods = ['POST'])
def save_item(user_id, item_id):
    """
    save an item with to user's saved_items list
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response(user_not_found,404)

    item = Item.query.filter_by(id=item_id).first()

    if item is None:
        return failure_response(item_not_found,404)
    if item in user.saved_items :
        return failure_response("item already saved",403)
   
    user.saved_items.append(item)
    db.session.commit()
    return success_response(user.serialize(), 201)

@app.route("/api/items/fulfill/<int:user_id>/<int:item_id>/", methods = ['POST'])
def fulfill_item(user_id, item_id):
    """
    Endpoint to add the user of user_id as a fulfiller for item of item_id.   
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response(user_not_found, 404)

    item = Item.query.filter_by(id=item_id).first()

    if item is None:
        return failure_response(item_not_found, 404)

    if not item.is_unfulfilled:
        return failure_response("This item is already has another user fulfilling this request", 403)

    # Conduct a transaction between the two users
    poster_user = User.query.filter_by(id= item.poster_id).first()

    if poster_user is None:
        return failure_response("The poster for this item was not found. Transaction couldn't be completed", 404)

    if item.poster_id == user_id:
        return failure_response("User cannot fulfill their own item request", 403) # cannot fulfill their own transaction

    item_credit_value = item.credit

    # Conduct transaction
    if item.is_borrow_type:
        # User is lending to poster
        # User wants to lend an item to poster_user with a cost of item_credit_value
        if poster_user.credit < item_credit_value:
            return failure_response("This user cannot lend their item since the poster doesn't have enough credits to borrow their item at this time.", 403)
        
        poster_user.credit -= item_credit_value
        user.credit += item_credit_value
        # Update user state, add lent items
        user.lend_items.append(item)

    else:
        # User is borrowing from the poster
        # User wants to borrow item from poster_user giving item_credit_value
        if user.credit < item_credit_value:
            return failure_response("This user cannot borrow this item since they doesn't have enough credits.", 403)
        user.credit -= item_credit_value
        poster_user.credit += item_credit_value
        # Update user state, add borrowed items
        user.borrow_items.append(item)

    # Update item state
    item.fulfiller_id = user.id # Add user as a fulfiller for the item of item_id
    item.is_unfulfilled = False # Transaction is now fulfilled

    db.session.commit()
    # Future plan:
    # Add a report system to affect ratings if users don't deliver on rating

    return success_response(item.serialize(), 201)

@app.route("/api/items/rating/<int:item_id>/", methods = ['POST'])
def rate_transaction(item_id):
    """
    Endpoint to submit the user_rating after the transaction
    """
    
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response(item_not_found, 404)
    body = json.loads(request.data)
    
    user_id = body.get("user_id") # user that is DOING the rating
    rating = body.get("rating")

    user = User.query.filter_by(id = user_id).first()
    if user.id == item.poster_id:
        # poster rating the fulfiller
        if item.fulfiller_is_rated:
            return failure_response("This user already rated this transaction", 403)
        user_being_rated = User.query.filter_by(id = item.fulfiller_id).first()
        item.fulfiller_is_rated = True
    elif user.id == item.fulfiller_id:
        # fulfiller rating the poster
        if item.poster_is_rated:
            return failure_response("This user already rated this transaction", 403)
        user_being_rated = User.query.filter_by(id = item.poster_id).first()
        item.poster_is_rated = True
    else:
        return failure_response("This user is not involved with this transaction, so they cannot rate the users.", 403)

    if type(rating) != float or rating > 5 or rating < 0:
        return failure_response("Invalid rating. Please put in an number from 0 to 5", 403)

    total_rating_sum = user_being_rated.rating * (user_being_rated.num_ratings)
    total_rating_sum += rating # Add this new rating
    user_being_rated.num_ratings += 1
    user_being_rated.rating = total_rating_sum/user_being_rated.num_ratings 
   

    db.session.commit()
    return success_response(item.serialize(), 201)


# --------------------------------------------------------------
# ----------------------- DELETE REQUESTS ----------------------
# --------------------------------------------------------------

@app.route("/api/items/<int:user_id>/<int:item_id>/", methods = ['DELETE'])
def delete_item(user_id, item_id):
    """
    delete an item
    """
    item = Item.query.filter_by(id= item_id).first()

    if item is None:
        return failure_response(item_not_found,404)
    if item.poster_id != user_id:
        return failure_response("user does not have permission to edit this post",403)
    
    if not item.is_unfulfilled:
        # We make it so you can't delete an item that is being fulfilled so
        # users can't cut the transaction short.
        return failure_response("Can't delete an item that is in the process of being fulfilled",403)

    db.session.delete(item)
    db.session.commit()
    return success_response(item.serialize(), 202)
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)