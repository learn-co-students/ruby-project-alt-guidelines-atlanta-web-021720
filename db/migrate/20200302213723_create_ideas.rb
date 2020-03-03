class CreateIdeas < ActiveRecord::Migration[5.2]
  def change
    create_table :ideas do |t|
      t.string :title
      t.text :post
      t.timestamps
      t.integer :generator_id
    end
  end
end
