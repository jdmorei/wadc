class CreateInterfaces < ActiveRecord::Migration
  def change
    create_table :interfaces do |t|
      t.string :name
      t.string :address
      t.string :mask
      t.string :gateway
      t.string :dns

      t.timestamps null: false
    end
  end
end
