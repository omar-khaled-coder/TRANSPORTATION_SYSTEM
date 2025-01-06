class CreateJoinTableDriversTrucks < ActiveRecord::Migration[7.1]
  def change
    create_join_table :drivers, :trucks do |t|
      # t.index [:driver_id, :truck_id]
      # t.index [:truck_id, :driver_id]
    end
  end
end
