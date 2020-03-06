class Idea < ActiveRecord::Base
    has_many :stashes
    belongs_to :user

    def implementers
        self.stashes.users.where(datatype: "Implementer")
    end
end