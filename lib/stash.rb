class Stash < ActiveRecord::Base
    belongs_to :implementer
    belongs_to :idea
end