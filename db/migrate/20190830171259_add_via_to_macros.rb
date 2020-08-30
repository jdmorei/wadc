class AddViaToMacros < ActiveRecord::Migration
  def change
    add_column :macros, :via, :string
  end
end
