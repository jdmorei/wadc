class TelnetController < ApplicationController

  $sesionesTelnet=Hash.new

  class Par
    attr_accessor :telnet, :command, :banner, :dispositivo

    def initialize d, t, b
      @dispositivo = d
      @telnet = t
      @banner= b
      @command = 0


    end

  end

  def terminal

    begin
    @d = current_user.dispositivos.find(params[:id])
    puts @d.ip
    puts @d.nombre
    puts @d.passtelnet
    puts @d.fabricante
    puts  @d.fabricante.to_s != "Cisco"
    intro = ""
    if @d.fabricante.to_s != "Cisco" then
      t = Net::Telnet::new("Host" => "#{@d.ip}",
                           "Timeout" => 10,
                           "Prompt" => /[#>:]\z*|has been enabled\z*/n)
                        #   "Prompt" => /[$%#>:] \z/n)
      t.login("#{@d.nombre}", "#{@d.passtelnet}") { |c| intro << c }
    else
      t = Net::Telnet::new("Host" => "#{@d.ip}",
                            "Timeout" => 5,
                            "Prompt" => /^Username:|[#]/ )

      t.cmd("\n#{@d.nombre}") { |c| intro << c }
      t.cmd("#{@d.passtelnet}") { |c| intro << c }
      # t.print("enable") { |c| intro << c }
      t.cmd("\n") { |c| intro << c }
      #tn.close



    end

    puts "aqui llega?"
    p=Par.new @d, t, intro
    $sesionesTelnet[1]=p
    rescue Exception => e
      render :text => "Error connecting through telnet"
    end



  end

  def input_command
    if $sesionesTelnet[1].command == 0
      render :text => $sesionesTelnet[1].banner
      $sesionesTelnet[1].command=$sesionesTelnet[1].command+1
    else

      patron = /.*?=(.*)$/
      cadena = request.original_url
      aux = cadena.scan patron
      cmd = URI.decode(aux.join)
      sal=""
      t=$sesionesTelnet[1].telnet
      t.cmd(cmd) { |c| sal<< c }
      puts sal
      @salida =sal
      $sesionesTelnet[1].command=$sesionesTelnet[1].command+1
      render :text => @salida
    end
    #render :layout => false
    #render sal
    #redirect_to telnet_output_command_path


  end

  def output_command

    render :layout => false

  end


end
