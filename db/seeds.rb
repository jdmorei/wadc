# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Usuario.destroy_all
Usuario.create! [
    {name: "admin", password: "admin", rol: "1", superusuario: ""},
    {name: "user", password: "usuario", rol: "2", superusuario: "1"},

                ]

Dispositivo.destroy_all
Dispositivo.create! [
    {tipo:"router",fabricante: "cisco", serie: "serie", modelo: "modelo", nombre:"routerWapo",
    fecha: "21/01/2000", descripcion: "routerouter",ip:"192.168.1.1", passenable: "p",
    passtelnet: "pas", passsh: "password"}
                    ]


