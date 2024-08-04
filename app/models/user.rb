class User < ApplicationRecord
  before_save {self.email = self.email.downcase}
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
end
