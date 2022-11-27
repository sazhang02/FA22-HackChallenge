from re import T, fullmatch
from db import Item, User, db
from flask import Flask, request
import json 
from datetime import datetime


app = Flask(__name__)
db_filename = "ShareVerse.db"

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
    item = Item.query.filter_by(id=item_id).first()
    if item is None:
        return failure_response("item not found")
    return success_response(item.serialize())

# --------------------- BORROWED ITEM INFORMATION------------------
@app.route("/api/items/borrow")
def get_all_borrowing_items():
    """
    get all the borrowing items in database
    """
    lst = []
    for item in Item.query.filter_by(is_borrow_type=True).all():
        lst.append(item.serialize())
    return success_response(lst, 201)

@app.route("/api/items/users/<int:user_id>/borrow")
def get_user_borrowing_items(user_id):
    """
    get all of the user's borrowing items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response("This user was not found")
    borrow_items = []
    for a in user.borrow_items:
        borrow_items.append(a.public_serialize())
    return borrow_items

# --------------------- LENT ITEM INFORMATION----------------------
@app.route("/api/items/lend")
def get_all_lending_items():
    """
    get all the lending items in database
    """
    lst = []
    for item in Item.query.filter_by(is_borrow_type=False).all():
        lst.append(item.serialize())
    return success_response(lst, 201)


@app.route("/api/items/users/<int:user_id>/lend")
def get_user_lending_items(user_id):
    """
    get all of the user's lending items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response("This user was not found")
    lend_items = []
    for a in user.lend_items:
        lend_items.append(a.public_serialize())
        print("===============",a.public_serialize())
    return lend_items

# --------------------- SAVED ITEM INFORMATION----------------------

@app.route("/api/items/users/<int:user_id>/saved")
def get_user_saved_items(user_id):
    """
    get all of the user's saved items
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response("This user was not found")
    saved_items = []
    for a in user.saved_items:
        saved_items.append(a.public_serialize())
    return saved_items

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
        return failure_response("This user was not found")
    body = json.loads(request.data)

    # Process request body if the user IS found
    itemname = body.get("itemname")
    due_date_str = body.get("due_date")
    location = body.get("location")
    credit_value = body.get("credit_value")
    is_borrow_type = body.get("is_borrow_type")
    image_url = body.get("image_url")

    # Check if request input is valid
    if (
        itemname is None or 
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
        itemname = itemname,
        due_date = due_date,
        location = location,
        poster_id = user_id,
        credit_value = credit_value,
        is_borrow_type = is_borrow_type,
        image_url = image_url,
        is_unfulfilled = True
    )

    # Add item to the user's lending/borrowing list
    if is_borrow_type == True:
        print("<><><><><><><><><>><<><<><<><><><><>><",user.borrow_items)
        print("<><><><><><><><><>><<><<><<><><><><>><type type type type type",type(user.borrow_items))
        # user.borrow_items.append(new_item)
        print("<><><><><><><><><>><<><<><<><><><><>><",user.borrow_items)
    else: 
        # user.lend_items.append(new_item)
        print("<><><><><><><><><>><<><<><<><><><><>><",user.lend_items)

    # Add item to Item database
    db.session.add(new_item)
    db.session.commit()
    return success_response(new_item.serialize(), 201)


@app.route("/api/users/<int:user_id>/<int:item_id>", methods = ['POST'])
def update_item(user_id, item_id):
    """
    update an item with id item_id
    """
   
    item = Item.query.filter_by(id= item_id).first()
    if item is None:
        return failure_response("item not found")
    body = json.loads(request.data)
    if item.poster_id != user_id:
        return failure_response("user does not have permission to edit this post")
    iname = body.get("itemname")
    # due_date = due_date,
    location = body.get("location")

    credit_value = body.get("credit_value")
    image_url = body.get("image_url")

    if iname is not None:
        item.itemname = iname
    if location is not None:
        item.location =location
    if credit_value is not None:
        item.credit_value = credit_value
    if image_url is not None:
        item.image_url = image_url
    db.session.commit()
    return success_response(item.serialize(), 201)

@app.route("/api/users/<int:user_id>/<int:item_id>/saved", methods = ['POST'])
def save_item(user_id, item_id):
    """
    save an item with to user's saved_items list
    """
    user = User.query.filter_by(id= user_id).first()
    if user is None:
        return failure_response("user not found")
    item = Item.query.filter_by(id= item_id).first()
    if item is None:
        return failure_response("item not found")
    if item in user.saved_items:
        return failure_response("item already saved")
    user.saved_items.append(item)
    db.session.commit()
    return success_response(user.serialize(), 201)

# --------------------------------------------------------------
# ----------------------- DELETE REQUESTS ----------------------
# --------------------------------------------------------------

@app.route("/api/users/<int:user_id>/<int:item_id>/delete/", methods = ['DELETE'])
def delete_item(user_id, item_id):
    """
    delete an item
    """
    item = Item.query.filter_by(id= item_id).first()
    if item is None:
        return failure_response("item not found")
    if item.poster_id != user_id:
        return failure_response("user does not have permission to edit this post")
    db.session.delete(item)
    db.session.commit()
    return success_response(item.serialize(), 201)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)

