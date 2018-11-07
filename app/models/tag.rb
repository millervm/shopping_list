class Tag < ApplicationRecord
    has_and_belongs_to_many :items
    has_many :lists, through: :items
    has_many :users, through: :lists

    validates :name, uniqueness: {case_sensitive: false, message: "Tag must have a unique name."},
                    presence: {message: "Tag must have a name."},
                    length: {maximum: 50, message: "Tag name must have less than 50 characters."}
      
    scope :sort_by_name, -> { order('LOWER(name)') }
                    
    def self.case_insensitive_find_or_create_by_name(name)
        find_by('UPPER(name) = UPPER(?)', name) || create(name: name)
    end
                     
end
