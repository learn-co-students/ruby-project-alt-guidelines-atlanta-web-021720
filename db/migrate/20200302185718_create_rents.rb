class CreateRents < ActiveRecord::Migration[5.2]
  def change
    create_table :rents do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :free_event
      t.integer :user_id
      t.integer :movie_id
    end
  end
end
