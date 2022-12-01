from flask_sqlalchemy import SQLAlchemy
from enum import Enum
import base64
import boto3
import datetime
import io
from io import BytesIO
from mimetypes import guess_type, guess_extension
import os
from PIL import Image 
import random
import re
import string
import bcrypt
import hashlib

db = SQLAlchemy()
EXTENSIONS = ["png","gif","jpg","jpeg"]
BASE_DIR = os.getcwd()
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
S3_BASE_URL = f"https://{S3_BUCKET_NAME}.s3.us-east-1.amazonaws.com"

class User(db.Model):
    """
    User Model
    Has a one-to-many relationship with Item model
    """
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable = False)
    # User information
    email = db.Column(db.String, nullable=False, unique=True)
    password_digest = db.Column(db.String, nullable=False) # encrypted password for authentification

    credit = db.Column(db.Integer, nullable = False)
    rating = db.Column(db.Integer, nullable = False)
    profile_image_url= db.Column(db.String)

    lend_items_id = db.Column(db.Integer, db.ForeignKey("item.id"))
    borrow_items_id = db.Column(db.Integer, db.ForeignKey("item.id"))
    saved_items_id = db.Column(db.Integer, db.ForeignKey("item.id"))

    lend_items = db.relationship("Item", cascade="delete", foreign_keys=[lend_items_id], uselist=True)
    borrow_items = db.relationship("Item", cascade="delete", foreign_keys=[borrow_items_id], uselist=True)
    saved_items = db.relationship("Item", cascade="delete", foreign_keys=[saved_items_id], uselist=True)

    # Session information for authentification
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        """
        Initializes a User object
        """
        self.username = kwargs.get("username")
        self.email = kwargs.get("email")
        self.password_digest = bcrypt.hashpw(kwargs.get("password").encode("utf8"), bcrypt.gensalt(rounds=13))
        self.renew_session()

        self.credit = kwargs.get("credit", 20)
        self.rating = kwargs.get("rating", 5)
        self.profile_image_url = kwargs.get("profile_image_url")

    def public_serialize(self):
        """
        Serializes a User without account specific information -- lend_items 
        and borrow_items
        """
        return {
            "id": self.id,
            "username": self.username,
            "credit": self.credit,
            "rating": self.rating,
            "profile_image_url": self.profile_image_url
        }

    def serialize(self):
        """
        constructs users with all fields as a python dictionary
        """
        print(type(self.lend_items))

        lend_items = []
        for a in self.lend_items:
            lend_items.append(a.public_serialize())

        borrow_items = []
        for a in self.borrow_items:
            borrow_items.append(a.public_serialize())

        saved_items = []
        for a in self.saved_items:
            saved_items.append(a.public_serialize())
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "credit": self.credit,
            "rating": self.rating,
            "profile_image_url": self.profile_image_url,
            "lend_items": lend_items,
            "borrow_items":borrow_items,
            "saved_items":saved_items
        }

    # ---- Authentification functions -----
    def _urlsafe_base_64(self):
        """
        Randomly generates hashed tokens (used for session/update tokens)
        """
        return hashlib.sha1(os.urandom(64)).hexdigest()

    def renew_session(self):
        """
        Renews the sessions, i.e.
        1. Creates a new session token
        2. Sets the expiration time of the session to be a day from now
        3. Creates a new update token
        """
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        """
        Verifies the password of a user
        """
        return bcrypt.checkpw(password.encode("utf8"), self.password_digest)

    def verify_session_token(self, session_token):
        """
        Verifies the session token of a user
        """
        return session_token == self.session_token and datetime.datetime.now() < self.session_expiration

    def verify_update_token(self, update_token):
        """
        Verifies the update token of a user
        """
        return update_token == self.update_token


class Item(db.Model):
    """
    Item Model
    Has a many-to-many relationship with User model
    """
    __tablename__ = "item"
    id = db.Column(db.Integer, primary_key=True, autoincrement = True)
    item_name = db.Column(db.String, nullable = False)
    due_date = db.Column(db.DateTime(timezone=True), nullable = False)
    location = db.Column(db.String, nullable = False)
    poster_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = False)
    fulfiller_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = True)

    credit_value = db.Column(db.Integer, nullable = False)
    is_borrow_type = db.Column(db.Boolean, nullable = False)
    is_unfulfilled = db.Column(db.Boolean, nullable = False)
    image_url = db.Column(db.String, nullable = True)

    def __init__(self, **kwargs):
        """
        Initializes a Item object
        """
        self.item_name = kwargs.get("item_name")
        self.due_date = kwargs.get("due_date")
        self.location = kwargs.get("location")

        self.credit_value = kwargs.get("credit_value")
        self.is_borrow_type = kwargs.get("is_borrow_type")
        self.is_unfulfilled = kwargs.get("is_unfulfilled", True)
        self.image_url = kwargs.get("image_url")

    def serialize(self):    
        """
        Serializes a Item object
        """
        poster_user = User.query.filter_by(id = self.poster_id).first()
        serialized_poster = poster_user.public_serialize()
        if self.fulfiller_id is not None:
            fulfiller_user = User.query.filter_by(id = self.fulfiller_id).first()
            serialized_fulfiller = fulfiller_user.public_serialize()
        else:
            serialized_fulfiller = None
        return {
            "id": self.id,
            "item_name": self.item_name,
            "due_date": self.due_date.strftime('%m/%d/%Y %H'),
            "location": self.location,
            "poster_user": serialized_poster,
            "fulfiller_user": serialized_fulfiller,
            "credit_value": self.credit_value,
            "is_borrow_type": self.is_borrow_type,
            "is_unfulfilled": self.is_unfulfilled,
            "image_url": self.image_url
        }

    def public_serialize(self):
        """
        Serializes an Item without transaction specific information
        """
        return {
            "id": self.id,
            "item_name": self.item_name
        }


class Image(db.Model):
    """
    Image Model
    """
    __tablename__ = "image"
    id = db.Column(db.Integer, primary_key=True, autoincrement = True)
    base_url = db.Column(db.String, nullable = False)
    salt = db.Column(db.String, nullable = False)
    extension = db.Column(db.String, nullable = False)
    width = db.Column(db.Integer, nullable = False)
    height = db.Column(db.Integer, nullable = False)
    created_at = db.Column(db.DateTime, nullable = False)

    def __init__(self,**kwargs):
        """
        Initializes an Image object
        """
        self.create(kwargs.get("image_data"))

    def serialize(self):
        """
        Serializes an Image Object
        """
        return {
            "url":f"{self.base_url}/{self.salt}.{self.extension}",
            "created_at": str(self.created_at)}
    def create(self, image_data):
        """
        Given an image in base64 encoding, does the following:
        1. Rejects the image if it is not a supported file type ["png","gif","jpg","jpeg"]
        2. Generate a random string for the image filename
        3. Decode the image and attempts to upload to AWS
        """
        try:
            ext = guess_extension(guess_type(image_data)[0])[1:]
            if ext not in EXTENSIONS:
                raise Exception(f"Extension {ext} is not valid!")
            salt = "".join(
                random.SystemRandom().choice(
                    string.ascii_uppercase + string.digits
                )
                for _ in range (16)
            )
            img_str=re.sub("^data:image/.+;base64,","",image_data)
            img_data=base64.b64decode(img_str)
            img = Image.open(BytesIO(img_data))
            self.base_url = S3_BASE_URL
            self.salt = salt
            self.extension = ext
            self.width=img.width
            self.height=img.height
            self.created_at=datetime.datetime.now()
            img_filename = f"{self.salt}.{self.extension}"
            self.upload(img,img_filename)

        except Exception as e:
            #in case AWS goes down
            print(f"Error when creating image:{e}")
    
    def upload(self, img, img_filename):
        """
        Attempts to upload the image into the specified S3 bucket
        """
        try:
            #save image into temporary location
            img_temp_loc = f"{BASE_DIR}/{img_filename}"
            img.save(img_temp_loc)
            #upload image into S3 bucket
            s3_client = boto3.client("s3")
            s3_client.upload_file(img_temp_loc,S3_BUCKET_NAME,img_filename)
            s3_resource = boto3.resource("s3")
            object_acl = s3_resource.ObjectAcl(S3_BUCKET_NAME,img_filename)
            object_acl.put(ACL="public-read")
            os.remove(img_temp_loc)

        except Exception as e:
            print(f"Error when uploading image:{e}")