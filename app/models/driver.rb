class Driver < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  has_and_belongs_to_many :trucks, join_table: :drivers_trucks
  has_many :drivers_trucks
  has_many :trucks, through: :drivers_trucks
end
