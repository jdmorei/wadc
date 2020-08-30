class Integra
  attr_accessor :nombre,:direccion

  def initialize nom, dir
    @nombre=nom
    @direccion=dir

  end

  def newCacti

  end


  def newIntegra

  end

  def to_s
    result="Se crea una integracion de #{@nombre} en #{direccion}"
    return result
  end




end