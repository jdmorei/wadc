class CreateDispositivos < ActiveRecord::Migration
  def change
    create_table :dispositivos do |t|
      t.string :tipo
      t.string :fabricante
      t.string :serie
      t.string :modelo
      t.string :nombre
      t.date :fecha
      t.text :descripcion
      t.string :ip
      t.string :passenable
      t.string :passtelnet
      t.string :passsh
      t.references :usuario, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
