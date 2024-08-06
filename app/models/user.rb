class User < ApplicationRecord
  before_save do
    email.downcase!
    username.downcase!
  end
  validates :name,
            presence: true,
            length: {
              minimum: 1,
              maximum: 50
            }
  validates :username,
            uniqueness: true,
            presence: true,
            length: {
              minimum: 1,
              maximum: 50
            }
  validates :email,
            presence: true,
            uniqueness: true,
            length: {
              maximum: 255
            },
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }
  validates :password,
            presence: true,
            length: {
              minimum: 6
            }
  validates :bio,
            length: {
              minimum: 0,
              maximum: 200
            }
  has_secure_password
end
