class Idea < ActiveRecord::Base
    has_many :stashes
    has_many :implementers, through: :saves
    belongs_to :generator
end