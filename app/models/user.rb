class User < ActiveRecord::Base
  has_secure_password

  has_many :games

  validates :username, presence: true
  validates :password_digest, presence: true

end
