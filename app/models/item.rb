class Item < ApplicationRecord
    belongs_to :list
    belongs_to :user
    
    validates :name, presence: {message: "Your item must have a name."}
    validates :description, length: {maximum: 500, message: "Your description must have less than 500 characters."}
end
