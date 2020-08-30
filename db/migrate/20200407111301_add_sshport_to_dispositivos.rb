class AddSshportToDispositivos < ActiveRecord::Migration
  def change
    add_column :dispositivos, :sshport, :integer
  end
end
