class Rent < ActiveRecord::Base
    belongs_to :user
    belongs_to :movie

    def get_user_name
        self.user.name
    end

    def get_user_id
        if user!=nil
            self.user.id
        else
            nil
        end
    end

    def get_login_id
        self.user.login_id
    end

    def get_movie_name
        self.movie.name
    end

    def get_movie_id
        self.movie.id
    end

    def get_state
        if self.return
            "return"
        else
            "rent"
        end
    end

    def self.get_rent_count(customer)
        count = 0;
        self.all.each do |rent|
            if rent.get_user_id != nil && rent.get_user_id == customer.id && rent.get_state =="rent"
                count = count + 1;
            end
        end  
        count
    end
end
