class AddUsernameToDispositivos < ActiveRecord::Migration
  def change
    add_column :dispositivos, :username, :string
  end
end
