from flask_sqlalchemy import SQLAlchemy
from enum import Enum
db = SQLAlchemy()


class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable = False)
    email = db.Column(db.String, nullable = False)
    credit = db.Column(db.Integer, nullable = False)
    rating = db.Column(db.Integer, nullable = False)
    profile_image_url= db.Column(db.String)
    lend_items = db.relationship("Item", cascade="delete")
    # borrow_items = db.relationship("Item", cascade="delete")

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
            "lend_items": [a.partial_serialize() for a in self.lend_items], 
            # "borrow_items":[a.partial_serialize() for a in self.borrow_items]
        }
    def partial_serialize(self):
        """
        constructs users without course field as a python dictionary
        """
        return {
            "id": self.id,
            "username": self.username,
            "credit": self.credit,
            "rating": self.rating,
            "profile_image_url": self.profile_image_url
        }

class Item(db.Model):
    __tablename__ = "items"
    id = db.Column(db.Integer, primary_key=True)
    itemname = db.Column(db.String, nullable = False)
    lender_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    # borrower_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    end_date = db.Column(db.DateTime(timezone=True), nullable = False)
    return_date = db.Column(db.DateTime(timezone=True), nullable = False)
    credit_value = db.Column(db.Integer, nullable = False)
    post_type = db.Column(db.Boolean, nullable = False)
    post_status = db.Column(db.Boolean, nullable = False)

    def serialize(self):    
        """
        constructs assignment with all fields as a python dictionary
        """
        if self.post_type == True:
            return {        
                "id": self.id,        
                "itemname": self.itemname,        
                "due_date": self.due_date, 
                "lender": User.query.filter_by(id = self.lender_id).first().partial_serialize(),
                "end_date": self.end_date,
                "credit_value": self.credit_value,
                "post_type":"Lend",
                "post_status": "Unfulfilled"}
  
        return {        
        "id": self.id,        
        "itemname": self.itemname,        
        "due_date": self.due_date, 
        # "borrower": User.query.filter_by(id = self.borrower_id).first().partial_serialize(),
        "return_date": self.return_date,
        "credit_value": self.credit_value,
        "post_type":"Borrow",
        "post_status": "Unfulfilled"
    }


