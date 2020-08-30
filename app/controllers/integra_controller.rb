class IntegraController < ApplicationController
  $integra_global=Hash.new

  def show
    #before_filter :allow_iframe_requests
    response.headers.delete('X-Frame-Options')

    #response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM #{:dir}"

    @nom=@_params[:nom]
    @dir=@_params[:dir]
  end

  def index
    $integra_global=Hash.new


    File.open("#{Rails.root}/public/integra/third_party", 'r') do |f|
      while linea = f.gets
        puts linea
        nombre, direccion = linea.split ','
        i=Integra.new nombre,direccion
        $integra_global[i.nombre.to_sym]=i
      end

    end


  end

  def create

    n = params["/integra/create"][:nombre]
    d = params["/integra/create"][:direccion]

    i=Integra.new n,d

    $integra_global[i.nombre.to_sym]=i

    File.open("#{Rails.root}/public/integra/third_party", 'w') do |f|
      $integra_global.each do |i|
      f.puts i[1].nombre.to_s+","+i[1].direccion.to_s
     end
    end

    redirect_to integra_index_path


  end

  def delete

    nom=params[:i]

     $integra_global.delete(nom.to_sym)


    File.open("#{Rails.root}/public/integra/third_party", 'w') do |f|
      $integra_global.each do |i|
        f.puts i[1].nombre.to_s+","+i[1].direccion.to_s
      end
    end

    redirect_to integra_index_path
  end
end
