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

db = SQLAlchemy()
EXTENSIONS = ["png","gif","jpg","jpeg", "jpe"]
BASE_DIR = os.getcwd()
S3_BUCKET_NAME = os.environ.get("S3_BUCKET_NAME")
S3_BASE_URL = f"https://{S3_BUCKET_NAME}.s3.us-east-1.amazonaws.com"

lend_assoc = db.Table("lend_association", db.Model.metadata,
    db.Column("item_id", db.Integer, db.ForeignKey("item.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
)

borrow_assoc = db.Table("borrow_association", db.Model.metadata,
    db.Column("item_id", db.Integer, db.ForeignKey("item.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
)

saved_assoc = db.Table("saved_association", db.Model.metadata,
    db.Column("item_id", db.Integer, db.ForeignKey("item.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("user.id"))
)

class User(db.Model):
    """
    User Model
    Has a one-to-many relationship with Item model
    """
    __tablename__ = "user"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable = False)
    email = db.Column(db.String, nullable = False)
    credit = db.Column(db.Integer, nullable = False)
    rating = db.Column(db.Integer, nullable = False)
    profile_image_url= db.Column(db.String)
    num_transactions = db.Column(db.Integer, nullable = False)
    num_ratings =  db.Column(db.Integer, nullable = False)

    saved_items = db.relationship("Item", secondary=saved_assoc, back_populates='saved_users')
    borrow_items = db.relationship("Item", secondary=borrow_assoc, back_populates='borrow_users')
    lend_items = db.relationship("Item", secondary=lend_assoc, back_populates='lend_users')

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
            "profile_image_url": self.profile_image_url,
            "num_transactions": self.num_transactions,
            "num_ratings": self.num_ratings
        }

    def serialize(self):
        """
        constructs users with all fields as a python dictionary
        """
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "credit": self.credit,
            "rating": self.rating,
            "profile_image_url": self.profile_image_url,
            "lend_items": [l.public_serialize() for l in self.lend_items],
            "borrow_items": [b.public_serialize() for b in self.borrow_items],
            "saved_items": [s.public_serialize() for s in self.saved_items],
            "num_transactions": self.num_transactions,
            "num_ratings": self.num_ratings
        }


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

    saved_users = db.relationship("User", secondary=saved_assoc, back_populates='saved_items')
    borrow_users = db.relationship("User", secondary=borrow_assoc, back_populates='borrow_items')
    lend_users = db.relationship("User", secondary=lend_assoc, back_populates='lend_items')
    is_borrow_type = db.Column(db.Boolean, nullable = False)
    credit = db.Column(db.Integer, nullable = False)
    is_unfulfilled = db.Column(db.Boolean, nullable = False)
    image_url = db.Column(db.String, nullable = True)
    poster_is_rated = db.Column(db.Boolean, nullable = False)
    fulfiller_is_rated = db.Column(db.Boolean, nullable = False)

    # def __init__(self, **kwargs):
    #     """
    #     Initializes a Item object
    #     """
    #     # self.item_name = kwargs.get("item_name")
    #     # TODO: imlement datetime functionality
    #     # self.due_date = kwargs.get("due_date")
    #     self.location = kwargs.get("location")
    #     self.poster_id = kwargs.get("poster_id")
    #     self.fulfiller_id = None
    #     self.credit = kwargs.get("credit")
    #     self.is_borrow_type = kwargs.get("is_borrow_type")
    #     self.is_unfulfilled = True
    #     self.image_url = kwargs.get("image_url")

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
            "credit": self.credit,
            "is_borrow_type": self.is_borrow_type,
            "is_unfulfilled": self.is_unfulfilled,
            "image_url": self.image_url,
            "poster_is_rated": self.poster_is_rated,
            "fulfiller_is_rated": self.fulfiller_is_rated
        }

    def public_serialize(self):
        """
        Serializes an Item without transaction specific information
        """
        return {
            "id": self.id,
            "item_name": self.item_name
        }



class Asset(db.Model):
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
        print("SUCCESSFULLY INITILIZE IMAGE DATA")

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
            print("<><<><><><<<<><<><><><>><<><><><><><><><> create function")
            img_str=re.sub("^data:image/.+;base64,","",image_data)
            print("THE BASE URL SHOULD BE ", S3_BASE_URL)
            img_data=base64.b64decode(img_str)
            print("THE BASE URL IS ", self.base_url)
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