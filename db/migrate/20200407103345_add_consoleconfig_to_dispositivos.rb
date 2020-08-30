class AddConsoleconfigToDispositivos < ActiveRecord::Migration
  def change
    add_column :dispositivos, :consoleconfig, :string
  end
end
