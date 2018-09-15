class User < ApplicationRecord
    has_secure_password(validations: false)
    has_many :lists
    has_many :items, through: :lists
    
    before_save {self.name = name.downcase}
    
    validates :name, uniqueness: {case_sensitive: false, message: "That username is already in use. Please chooose another."},
                    presence: {message: "You must enter a name."},
                    length: {maximum: 50, message: "Your name must have less than 50 characters."}
    validates :password, presence: {message: "You must enter a password."},
                        length: {in: 6..50, message: "Your password must have 6-40 characters."},
                        on: :create
    validates :password, presence: {message: "You must enter a password."},
                        length: {in: 6..50, message: "Your password must have 6-40 characters."},
                        on: :update, if: :password_digest_changed?
                        
    
    def urgent_list_items
        urgent = {}
        self.lists.each do |list|
            urgent[list] = list.urgent_items.collect {|item| item} if !list.urgent_items.empty?
        end
        urgent
    end
    
    def self.from_omniauth(auth)
        user = find_or_create_by(uid: auth.uid, provider: auth.provider)
          user.provider = auth.provider
          user.uid = auth.uid
          user.name = auth.info.name
          user.save!
        user
    end
    
end
