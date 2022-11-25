from flask_sqlalchemy import SQLAlchemy
from enum import Enum
db = SQLAlchemy()


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

    lend_items_id = db.Column(db.Integer, db.ForeignKey("item.id"))
    borrow_items_id = db.Column(db.Integer, db.ForeignKey("item.id"))
    saved_items_id = db.Column(db.Integer, db.ForeignKey("item.id"))

    lend_items = db.relationship("Item", cascade="delete", foreign_keys=[lend_items_id], uselist=True)
    borrow_items = db.relationship("Item", cascade="delete", foreign_keys=[borrow_items_id], uselist=True)
    saved_items = db.relationship("Item", cascade="delete", foreign_keys=[saved_items_id], uselist=True)
    # TODO: add saved items?

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


class Item(db.Model):
    """
    Item Model
    Has a many-to-many relationship with User model
    """
    __tablename__ = "item"
    id = db.Column(db.Integer, primary_key=True, autoincrement = True)
    itemname = db.Column(db.String, nullable = False)
    due_date = db.Column(db.DateTime(timezone=True), nullable = False)
    location = db.Column(db.String, nullable = False)
    poster_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = False)
    fulfiller_id = db.Column(db.Integer, db.ForeignKey("user.id"), nullable = True)

    credit_value = db.Column(db.Integer, nullable = False)
    is_borrow_type = db.Column(db.Boolean, nullable = False)
    is_unfulfilled = db.Column(db.Boolean, nullable = False)
    image_url = db.Column(db.String, nullable = True)

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
    #     self.credit_value = kwargs.get("credit_value")
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
            "itemname": self.itemname,
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
            "itemname": self.itemname
        }