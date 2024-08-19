class ChangeActivatedDefaultToFalseToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :activated, false
  end
end
