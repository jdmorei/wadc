class AddNombreToMacro < ActiveRecord::Migration
  def change
    add_column :macros, :nombre, :string
  end
end
