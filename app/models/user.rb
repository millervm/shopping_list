class User < ApplicationRecord
    has_secure_password
    has_many :lists
    has_many :items, through: :lists
    
    #validations = individual usernames, must have name&password
end
