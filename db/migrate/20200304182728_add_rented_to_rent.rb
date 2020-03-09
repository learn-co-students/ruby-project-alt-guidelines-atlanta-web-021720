class AddRentedToRent < ActiveRecord::Migration[5.2]
  def change
      add_column :rents, :return, :boolean
  end
end
