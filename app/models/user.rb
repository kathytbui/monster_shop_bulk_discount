class User < ApplicationRecord
  validates :email, uniqueness: true, presence:true
  validates_presence_of :password_digest, require: true
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :orders
  belongs_to :merchant, optional: true

  has_secure_password

  enum role: %w(default merchant admin)
end
