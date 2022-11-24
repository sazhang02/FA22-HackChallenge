from re import T
from db import Item, User, db
from flask import Flask, request
import json 
import os


app = Flask(__name__)
db_filename = "ShareVerse.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

db.init_app(app)
with app.app_context():
    db.create_all()

# your routes here

@app.route("/api/users/") # TODO: Delete later, for testing
def get_all_users():
    """
    Endpoint for getting all users
    """
    users = [user.serialize() for user in User.query.all()]
    return success_response({"users": users})


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

@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    """
    get a specific user
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("user not found")
    return success_response(user.serialize())


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
    return success_response(user.serialize(), )


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
    if e is not None:
        user.email =e
    if image is not None:
        user.profile_image_url = image

    return success_response(user.serialize(), 201)

@app.route("/api/items/") # TODO: Delete later, for testing
def get_all_items():
    """
    Endpoint for getting all users
    """
    items = [item.serialize() for item in Item.query.all()]
    return success_response({"items": items})

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
    item_name = body.get("item_name")
    # due_date = body.get("due_date")
    location = body.get("location")
    credit_value = body.get("credit_value")
    is_borrow_type = body.get("is_borrow_type")
    image_url = body.get("image_url")

    # Check if request input is valid
    if (item_name is None or 
        # due_date is None or 
        location is None or
        credit_value is None or
        is_borrow_type is None):
        return failure_response("Missing parameters!", 400)

    # Create an item
    new_item = Item(
        item_name = item_name,
        # due_date = due_date,
        location = location,
        poster_id = user_id,
        credit_value = credit_value,
        is_borrow_type = is_borrow_type,
        image_url = image_url
    )

    # Add item to the user's lending/borrowing list
    if is_borrow_type:
        user.borrow_items.append(new_item)
    else: 
        user.lend_items.append(new_item)

    # Add item to Item database
    db.session.add(new_item)
    db.session.commit()
    return success_response(new_item.serialize(), 201)

# @app.route("/api/items/")
# def get_all_lending_items(user_id):
#     lst = []
#     for item in Item.query.filter_by(is_borrow_type=False).all():
#         lst.append(item.serialize())
#     return success_response(lst, 201)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)

