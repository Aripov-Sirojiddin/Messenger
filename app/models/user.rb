class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name,
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

  has_secure_password
end
