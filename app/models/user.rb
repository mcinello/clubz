class User < ApplicationRecord
  has_secure_password

  has_many :clubs

  validates :name, presence: true, uniqueness: true

  def self.allowed_roles
    ["wizard", "hobbit"]
  end

end
