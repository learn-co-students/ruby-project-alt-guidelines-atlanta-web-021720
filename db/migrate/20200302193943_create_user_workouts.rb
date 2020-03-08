class CreateUserWorkouts < ActiveRecord::Migration[5.2]
  def change
    create_table :user_workouts do |t|
      t.string :name
      t.integer :user_id
      t.integer :workout_id
      t.integer :workout_reps
      t.integer :workout_weight
      t.string :workout_type
      t.string :workout_name
      t.string :workout_time
    end
  end
end
