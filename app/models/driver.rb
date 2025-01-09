class Driver < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'is not a valid email' }
  validates :password, length: { minimum: 6 } # Password length validation

  has_and_belongs_to_many :trucks, join_table: :drivers_trucks
  has_many :drivers_trucks
  has_many :trucks, through: :drivers_trucks
end
