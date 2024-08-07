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
            format: {
              with: /\A[a-z]+([a-z]*[0-9]*_){0,2}[a-z]*[0-9]*\z/,
              message: "requires letters, may contain numbers and underscores"
            },
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

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
