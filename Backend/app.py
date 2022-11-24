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
    return json.dumps({"success": True, "data": data}, default=str), code

def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}, default=str), code

db.init_app(app)
with app.app_context():
    db.create_all()

# your routes here

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
        rating=0,
        profile_image_url=None,
        )

    db.session.add(new_user)
    db.session.commit()
    return success_response(new_user.serialize(), 201)


@app.route("/api/users/")
def get_courses():
    """
    Endpoint for getting all users
    """
    users = [user.serialize() for user in User.query.all()]
    return success_response({"users": users})



@app.route("/api/users/<int:user_id>/")
def get_user(user_id):
    """
    get a specific user
    """
    user = User.query.filter_by(id=user_id).first()
    if user is None:
        return failure_response("user not found")
    return success_response(user.serialize())


@app.route("/api/users/<int:user_id>/delete/", methods = ['DELETE'])
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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)

