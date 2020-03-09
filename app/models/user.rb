class User < ActiveRecord::Base
    has_many :rents
    has_many :movies, through: :rents
    validates :login_id, uniqueness: true
    validates :login_id, presence: true
    def get_movie_of_first_rent
        #return the movie of the artist's first saved rent
        self.rents.first.movie
    end
    
    def rent_count
    #return the number of rents associated with the user
        self.rents.count
    end

    def movie_count
    #return the number of movies associated with the user
        self.rents.map do |rent|
            rent.movie
        end.uniq.count
    end
end
