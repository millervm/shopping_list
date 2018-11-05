class Item < ApplicationRecord
    belongs_to :list, optional: true
    belongs_to :user, optional: true
    has_and_belongs_to_many :tags
    
    validates :name, presence: {message: "Item must have a name."}
    validates :description, length: {maximum: 500, message: "Your description must have less than 500 characters."}
    validates :list_id, presence: {message: "List must be specified."}
    validates :user_id, presence: {message: "User must be specified."}
    
    def self.complete
        where(complete: true)
    end
    
    def self.incomplete
        where(complete: false)
    end
    
    def self.urgent
        where(urgent: true)
    end
    
    def self.not_urgent
        where(urgent: false)
    end
    
end
