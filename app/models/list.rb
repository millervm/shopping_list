class List < ApplicationRecord
    belongs_to :user
    has_many :items
    
    validates :name, presence: true, message: "List must have a name."
    validates :name, uniqueness: true, scope: user, message: "You cannot have two lists with the same name."
end
