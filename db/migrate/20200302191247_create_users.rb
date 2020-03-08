class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name
      t.string :user_password
      t.string :name
      t.integer :age 
      t.integer :weight
      t.integer :height
    end
  end
end
