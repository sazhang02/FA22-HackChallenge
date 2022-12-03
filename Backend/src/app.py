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
        return failure_response("user not found")
    return success_response(user.serialize())

# --------------------------------------------------------------
# ------------------------ POST REQUESTS -----------------------
# --------------------------------------------------------------

@app.route("/api/users/", methods=["POST"])
def create_user():
    """
    create a user
    """
    body = json.loads(request.data)
    uname=body.get('username')
    e=body.get('email')
    if uname is None or e is None:
        return failure_response("please provide a username and email",400)
    if not fullmatch(email_regex, e):
        return failure_response("email not valid", 400)
    new_user = User(
        username= uname,
        email=e,
        credit=20,
        rating=5,
        profile_image_url=None,
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
        return failure_response("user not found")
    body = json.loads(request.data)
    uname = body.get("username")
    e = body.get("email")
    image=body.get("profile_image_url")
    if uname is not None:
        user.username = uname
    if e is not None and fullmatch(email_regex, e):
        user.email =e
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
        return failure_response("user not found", 404)
    db.session.delete(user)
    db.session.commit()
    return success_response(user.serialize(), 201)

# --------------------------------------------------------------
# --------------------------------------------------------------
# ----------------------- ITEM ENDPOINTS -----------------------
# --------------------------------------------------------------
# --------------------------------------------------------------



# --------------------------------------------------------------
# ------------------------ GET REQUESTS ------------------------
# --------------------------------------------------------------

# --------------------- ITEM INFORMATION------------------------
@app.route("/api/items/") # TODO: Delete later, for testing
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
    body = json.loads(request.data)
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response("item not found")
    return success_response(item.serialize())

# --------------------- BORROWED ITEM INFORMATION------------------
@app.route("/api/items/borrow/")
def get_all_borrowing_items():
    """
    get all the borrowing items in database
    """
    lst = [item.serialize() for item in Item.query.all()]
    return success_response({"borrow requests":lst}, 201)

@app.route("/api/items/borrow/<int:user_id>/")
def get_user_borrowing_items(user_id):
    """
    get all of the user's borrowing items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response("user not found")
    items = []
    for a in user.items:
        items.append(a.public_serialize())
    return success_response({"borrow requests":items}, 201)

# --------------------- LENT ITEM INFORMATION----------------------
@app.route("/api/items/lend/")
def get_all_lending_items():
    """
    get all the lending items in database
    """
    lst = [item.serialize() for item in Item.query.all()]
    return success_response({"lending items":lst}, 201)


@app.route("/api/items/lend/<int:user_id>/")
def get_user_lending_items(user_id):
    """
    get all of the user's lending items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response("user not found")
    items = []
    for a in user.items:
        items.append(a.public_serialize())
    return success_response({"lending items":items}, 201)

# --------------------- SAVED ITEM INFORMATION----------------------

@app.route("/api/items/saved/<int:user_id>/")
def get_user_saved_items(user_id):
    """
    get all of the user's saved items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response("This user was not found")
    saved_items = [s.serialize for s in user.saved_items]
    return success_response({"saved items":saved_items}, 201)

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
        return failure_response("user not found")
    body = json.loads(request.data)

    # Process request body if the user IS found
    item_name = body.get("item_name")
    due_date_str = body.get("due_date")
    location = body.get("location")
    credit_value = body.get("credit_value")
    is_borrow_type = body.get("is_borrow_type")
    image_data = body.get("image_data")

    # Check if request input is valid
    if (
        item_name is None or 
        due_date_str is None or 
        location is None or
        credit_value is None or
        is_borrow_type is None):
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
        credit_value = credit_value,
        is_borrow_type = is_borrow_type,
        image_url = upload(image_data),
        is_unfulfilled = True
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
        return failure_response("item not found")
    body = json.loads(request.data)

    # TODO: Should this check should be a frontend responsbility??
    if item.poster_id != user_id:
        return failure_response("user does not have permission to edit this post")

    if not item.is_unfulfilled:
        # This post has been accepted between two users, so we should not allow 
        # any edits to the post after this point
        return failure_response("The details of this post cannot be edited when it is being processed.")

    iname = body.get("item_name")
    # due_date = due_date,
    location = body.get("location")

    credit_value = body.get("credit_value")
    image_data = body.get("image_data")

    if iname is not None:
        item.item_name = iname
    if location is not None:
        item.location =location
    if credit_value is not None:
        item.credit_value = credit_value
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
        return failure_response("user not found")

    item = Item.query.filter_by(id=item_id).first()

    if item is None:
        return failure_response("item not found")
    if item in user.saved_items :
        return failure_response("item already saved")
   
    user.saved_items.append(item)
    db.session.commit()
    return success_response(user.serialize(), 201)

# --------------------------------------------------------------
# ----------------------- DELETE REQUESTS ----------------------
# --------------------------------------------------------------

@app.route("/api/items/<int:user_id>/<int:item_id>/", methods = ['DELETE'])
def delete_item(user_id, item_id):
    """
    delete an item
    """
    body = json.loads(request.data)
    item = Item.query.filter_by(id= item_id).first()

    if item is None:
        return failure_response("item not found")
    if item.poster_id != user_id:
        return failure_response("user does not have permission to edit this post")
    # TODO CANNOT DELETE IF IS A FULFILLER. If it has a fulfiller and is past the deadline, can still delete?
    if item.fulfiller_id != None and datetime.now() < item.due_date:
        return failure_response("The transaction is still in progress")
    db.session.delete(item)
    db.session.commit()
    return success_response(item.serialize(), 201)
    
# --------------------------------------------------------------
# ----------------------- IMAGE REQUESTS ----------------------
# --------------------------------------------------------------
def upload(image_data):
    """
    Endpoint for uploading an image to AWS given its base64 form,
    then storing/returning the URL of that image
    """
    if image_data is None:
        return failure_response("No base64 image found")
    asset = Asset(image_data = image_data)
    db.session.add(asset)
    db.session.commit()
    return asset.serialize()

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)

