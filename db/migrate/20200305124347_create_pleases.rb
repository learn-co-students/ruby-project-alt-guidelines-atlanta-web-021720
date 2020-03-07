class CreatePleases < ActiveRecord::Migration[5.2]
  def change
    create_table :pleases do |t|
      t.integer :user_id
      t.integer :idea_id
    end
  end
end
