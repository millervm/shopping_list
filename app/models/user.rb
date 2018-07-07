class User < ApplicationRecord
    has_secure_password(validations: false)
    has_many :lists
    has_many :items, through: :lists
    
    validates :name, presence: {message: "You must enter a name."}
    validates :name, length: {maximum: 50, message: "Your name must have less than 50 characters."}
    validates :password, presence: {message: "You must enter a password."}
    validates :password, length: {in: 6..50, message: "Your password must have 6-40 characters."}
    
    def urgent_list_items
        urgent = {}
        self.lists.each do |list|
            urgent[list] = list.urgent_items.collect {|item| item} if !list.urgent_items.empty?
        end
        urgent
    end
    
end
