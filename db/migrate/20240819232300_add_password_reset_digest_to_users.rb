class AddPasswordResetDigestToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_reset_digest, :string
    add_column :users, :password_reset_sent_at, :datetime
  end
end
