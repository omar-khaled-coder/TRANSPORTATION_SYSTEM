class AddAssignedDateToDriversTrucks < ActiveRecord::Migration[7.1]
  def change
    add_column :drivers_trucks, :assigned_date, :datetime
  end
end
