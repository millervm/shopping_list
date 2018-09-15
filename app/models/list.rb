class List < ApplicationRecord
    belongs_to :user, optional: true
    has_many :items
    
    validates :name, presence: {message: "List must have a name."},
                     uniqueness: {scope: :user_id, case_sensitive: false, message: "You cannot have two lists with the same name."}
    validates :user_id, presence: {message: "User must be specified."}
    
    def complete_items
        self.items.select do |item|
            item.complete
        end
    end
    
    def incomplete_items
        self.items.select do |item|
            !item.complete
        end
    end
    
    def urgent_items
        self.incomplete_items.select do |item|
            item.urgent
        end
    end
    
end
