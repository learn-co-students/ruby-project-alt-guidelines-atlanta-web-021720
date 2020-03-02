class CreateSaves < ActiveRecord::Migration[5.2]
  def change
    create_table :saves do |t|
      t.integer :idea_id
      t.integer :implementer_id
    end
  end
end
