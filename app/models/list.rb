class List < ApplicationRecord
    belongs_to :user
    has_many :items
    
    #validations = must have name
end
