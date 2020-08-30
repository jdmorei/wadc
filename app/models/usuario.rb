class Usuario < ActiveRecord::Base
  has_secure_password
  has_many :dispositivos
end
