class CreateGenerators < ActiveRecord::Migration[5.2]
  def change
    create_table :generators do |t|
      t.string :username
      t.string :email
    end
  end
end
