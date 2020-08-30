class CreateUsuarios < ActiveRecord::Migration
  def change
    create_table :usuarios do |t|
      t.string :name
      t.string :password_digest
      t.string :rol
      t.integer :superusuario

      t.timestamps null: false
    end
  end
end
