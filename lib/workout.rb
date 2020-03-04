class Workout < ActiveRecord::Base
has_many :user_workouts
has_many :users, through: :user_workouts
end