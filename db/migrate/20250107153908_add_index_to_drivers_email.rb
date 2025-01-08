class AddIndexToDriversEmail < ActiveRecord::Migration[7.1]
  def change
    add_index :drivers, :email, unique: true
  end
end
