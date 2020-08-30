class CreateMacros < ActiveRecord::Migration
  def change
    create_table :macros do |t|
      t.string :fabricante
      t.string :serie
      t.string :modelo
      t.string :inputs
      t.string :commands

      t.timestamps null: false
    end
  end
end
