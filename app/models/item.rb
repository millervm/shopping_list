class Item < ApplicationRecord
    belongs_to :list, optional: true
    belongs_to :user, optional: true
    
    validates :name, presence: {message: "Item must have a name."}
    validates :description, length: {maximum: 500, message: "Your description must have less than 500 characters."}
    validates :list_id, presence: {message: "List must be specified."}
    validates :user_id, presence: {message: "User must be specified."}
    
end
