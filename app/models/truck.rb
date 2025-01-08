class Truck < ApplicationRecord
  has_and_belongs_to_many :drivers, join_table: :drivers_trucks
  has_many :drivers_trucks
  has_many :drivers, through: :drivers_trucks
end
