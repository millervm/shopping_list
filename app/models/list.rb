class List < ApplicationRecord
    belongs_to :user, optional: true
    has_many :items
    
    #add active/current attribute, to segregate those "on hold"??
    
    validates :name, presence: {message: "List must have a name."},
                     uniqueness: {scope: :user_id, case_sensitive: false, message: "You cannot have two lists with the same name."}
    validates :user_id, presence: {message: "User must be specified."}
    
end
