class Implementer < ActiveRecord::Base
    has_many :stashes
    has_many :ideas, through: :stashes


end