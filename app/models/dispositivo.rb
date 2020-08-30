class Dispositivo < ActiveRecord::Base
  belongs_to :usuario
  $numeroSsh=4000


  def runMacro macro, via=nil


    if via== nil or via == ''
      viaAux=macro.via
    else
      viaAux = via
    end

    @dispositivo = self

    reemplazos=Array.new

    sentenciasFinales=Array.new


    macro.commands.each do |c|
      comando=c

      macro.inputs.each do |i|
        valor=parame[i.to_sym]
        comando = comando.gsub /#{i}/, valor

      end
      sentenciasFinales.push comando

    end


    if viaAux.downcase=="ssh" then
      sol =send_ssh @dispositivo.id, @dispositivo.ip, @dispositivo.nombre, @dispositivo.passsh, @dispositivo.sshport, sentenciasFinales
    elsif viaAux.downcase == "telnet" then
      sol = send_telnet @dispositivo.id, @dispositivo.ip, @dispositivo.nombre, @dispositivo.passtelnet,@dispositivo.telnetport, sentenciasFinales
    elsif viaAux.downcase == "console" then
      sol = send_console @dispositivo.id, @dispositivo.passenable, sentenciasFinales
    end


    @sol=sol

    return sol



  end

  private
  def send_ssh id, ip, user, pass, port, commands
    res = ""
    begin

      if is_port_open?(ip, port)

        commandsInterpreted= Array.new
        commands.each  do |cmd|
          c = interpreta cmd, id
          commandsInterpreted.append c
        end

        commandToExec = commandsInterpreted.join ";"
        ssh = Net::SSH.start(ip, user, :password => pass, :port =>port, :paranoid => false, :timeout => 15)

        result = ssh.exec!(commandToExec)
        res << result
        ssh.close

        return {status: 'success', msg: res.force_encoding("UTF-8") }
      else

        return {status: 'error', msg:"Port #{port} closed for #{ip}"}

      end
    rescue => e
      puts e
      return {status: 'error', msg:e}
    end
  end


  def send_telnet id, ip, user, pass, port, commands

    if is_port_open?(ip, port)

      conn = Net::Telnet::new("Host" => ip,
                              "Port"=> port,
                              "Timeout" => 15,
                              "Prompt" => /[$%#>] \z/n)
      salida=""
      conn.login(user, pass)


      commands.each do |com|
        com = interpreta com, id
        conn.cmd(com) { |c| salida<< c }
        salida<<'\n'
      end

      conn.close
      return {status: 'success', msg: salida.force_encoding("UTF-8") }

    else

      return {status: 'error', msg:"Port #{port} closed for #{ip}"}

    end

  end



  def send_telnet_ftp id, ip, user, pass, commands
    cmd = commands.join ";"
    conn = Net::Telnet::new("Host" => ip,
                            "Timeout" => 10,
                            "Prompt" => /[$%#>?] \z/n)

    salida=""
    conn.login(user, pass)


    commands.each do |com|
      com = interpreta com, id

      conn.cmd(com) { |c| salida<< c }
      salida<<'\n'
    end

    conn.close
    salida= salida
    return salida.force_encoding("UTF-8")

  end



  def send_console id, pass, commands

    port_str = "/dev/ttyUSB0" #may be different for you
    baud_rate = 9600
    data_bits = 8
    stop_bits = 1
    parity = SerialPort::NONE

#sp = SerialPort.new(port_str,baud_rate,data_bits,stop_bits,parity)
    s = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)

# ENVIO DE COMANDOS PARA RESETEAR LA CONTRASEÑAç

    commands.each do |c|
      puts "ESTAMOSSSS CON LOS COMANDOSSS #{c}"
      puts c
      c = interpreta c, id

      # if c == "boot" then
      #   s.syswrite "#{c}\r"
      #   sleep 120
      # end

      if c == "enable" then
        s.syswrite "#{c}\r"
        sleep 2
        s.syswrite "#{pass}\r"
      elsif c == "\n" then
        s.syswrite "\r"
      end

      s.syswrite "#{c}\r"
      sleep 2

    end


    s.close
    return "MACRO POR CONSOLA REALIZADA"

  end

  #Este comando sirve para interpretar las palabras reservadas
  def interpreta command, idDispositivo

    #PATRONES
    pattern_sleep=/^sleep\((\d*)\)$/
    pattern_linebreak = /^CR\(\)$/
    pattern_random =/\+random\((\d*)\)/
    pattern_break=/^break()$/
    pattern_pass_enable = /passwordenable()/
    pattern_pass_telnet = /passwordtelnet()/
    pattern_pass_ssh = /passwordssh()/


    case command

      when pattern_sleep

        sleep $1.to_i


        return "\n"

      when pattern_linebreak

        return "\n"


      when pattern_random

        rand = /(\+random\(\d*\))/
        valor= $1.to_i
        alea= rand valor
        salida= command.gsub rand, alea.to_s

        return salida

      when pattern_break

        return "\x02"

      when pattern_pass_enable
        dis = current_user.dispositivos.find_by_id idDispositivo
        salida= command.gsub rand, dis.passenable

        return salida

      when pattern_pass_telnet
        dis = current_user.dispositivos.find_by_id idDispositivo
        salida= command.gsub rand, dis.passtelnet

        return salida

      when pattern_pass_ssh
        dis = current_user.dispositivos.find_by_id idDispositivo
        puts "*******************************"
        puts "*******************************"

        puts dis.nombre
        puts dis.fabricante
        puts dis.passsh

        puts "*******************************"

        puts "*******************************"
        salida= command.gsub "passwordssh()", dis.passsh.to_s

        return salida


      else

        return command

    end


  end



  def is_port_open?(ip, port)
    begin
      Timeout::timeout(10) do
        begin
          s = TCPSocket.new(ip, port)
          s.close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          return false
        end
      end
    rescue Timeout::Error
    end

    return false

  end




end
