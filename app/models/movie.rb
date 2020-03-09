class Movie < ActiveRecord::Base
    has_many :rents
    has_many :users, through: :rents

    has_many :movie_actors
    has_many :actors, through: :movie_actors

    has_many :movie_genres
    has_many :genres, through: :movie_genres

    def rent_count
      # return the number of rents in a genre
      rents.count
    end
  
    def actor_count
      # return the number of actors associated with the genre
      actors.count
    end
  
    def all_actor_names
      # return an array of strings containing every musician's name
      actors.map do |actor|
        actor.name
      end.uniq
    end

    def all_genre_names
      # return an array of strings containing every musician's name
      genres.map do |genre|
        genre.name
      end.uniq
    end
end