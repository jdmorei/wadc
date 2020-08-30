class AddOsversionToMacros < ActiveRecord::Migration
  def change
    add_column :macros, :osversion, :string
  end
end
