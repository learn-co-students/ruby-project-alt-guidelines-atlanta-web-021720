class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      # t.string :login_id, null: false
      t.string :login_id, index: {unique: true}, null: false
      t.string :password
      t.string :name
      t.integer :point 
    end
  end
end
