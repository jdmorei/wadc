class AddVersionToMacros < ActiveRecord::Migration
  def change
    add_column :macros, :version, :string
  end
end
