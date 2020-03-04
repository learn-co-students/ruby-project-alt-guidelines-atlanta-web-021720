class CreateWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :workouts do |t|
      t.string :name 
      t.string :workout_type
      t.integer :difficulty_rating
    end
  end
end
