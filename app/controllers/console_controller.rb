class ConsoleController < ApplicationController

  $sesionconsola

  class Hiloconsola < Thread
    def initialize t
      @t = t
    end

  end
  def new
    begin

      intro = ""
      t = Net::Telnet::new("Host" => "127.0.0.1",
                                   "Timeout" => 10,
                                   "Port" => 8000,
                                   "Prompt" => /[#>:]\z*|has been enabled\z*/n)
     # t.login("#{@d.nombre}", "#{@d.passtelnet}") { |c| intro << c }
      hc= Hiloconsola.new t
      hc.run
      $sesionconsola=hc
    rescue Exception => e
      render :text => "Error connecting through console"
    end

  end

  def input

      patron = /.*?=(.*)$/
      cadena = request.original_url
      aux = cadena.scan patron
      cmd = URI.decode(aux.join)
      sal=""
      t=$sesionconsola.t
      t.cmd(cmd) { |c| sal<< c }
      #puts sal
      if  cmd == "exit" then
        t.stop
      end
      @salida =sal
      render :text => @salida
    end
  end
