class User < ApplicationRecord
    has_secure_password
    has_many :lists
    has_many :items, through: :lists
    
    validates :name, presence: true, message: "You must enter a name."
    validates :name, {:length => {maximum: 50}, message: "Your name must have less than 50 characters."}
    validates :password, presence: true, message: "You must enter a password."
    validates :password, {:length => {in: 6..50}, message: "Your password must have 6-40 characters."}
    
end
