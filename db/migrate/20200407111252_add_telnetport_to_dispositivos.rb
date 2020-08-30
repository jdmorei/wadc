class AddTelnetportToDispositivos < ActiveRecord::Migration
  def change
    add_column :dispositivos, :telnetport, :integer
  end
end
