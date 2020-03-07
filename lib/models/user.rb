class User < ActiveRecord::Base
    has_many :ideas
    has_many :stashes
    has_many :pleases

    def stashed_ideas
        self.stashes.map do |stash|
            stash.idea
        end
    end

    def pleased_ideas
        self.pleases.map do |please|
            please.idea
        end
    end

end