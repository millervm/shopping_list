class List < ApplicationRecord
    belongs_to :user
    has_many :items
    
    validates :name, presence: {message: "List must have a name."}
    validates :user_id, uniqueness: {scope: :name, message: "You cannot have two lists with the same name."}
    
    def complete_items
        self.items.select do |item|
            iten if item.complete
        end
    end
    
    def incomplete_items
        self.items.select do |item|
            item if !item.complete
        end
    end
    
    def urgent_items
        self.incomplete_items.select do |item|
            item if item.urgent
        end
    end
    
end
