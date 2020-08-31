class DispositivosController < ApplicationController
  before_action :set_dispositivo, only: [:show, :edit, :update, :destroy]
  $numeroSsh=4000
  DIRECCIONFTP = "/home/equipo/RubymineProjects/iDRASCS/app/models"


  # GET /dispositivos
  # GET /dispositivos.json
  def index
    @dispositivos = current_user.dispositivos.all
  end

  # GET /dispositivos/1
  # GET /dispositivos/1.json
  def show
  end

  # GET /dispositivos/new
  def new
    @dispositivo = current_user.dispositivos.new

  end


  def create
    @dispositivo = Dispositivo.new(dispositivo_params)

    @dispositivo.usuario_id= current_user.id
    systemlog "create new device: #{@dispositivo.nombre}"

    respond_to do |format|
      if @dispositivo.save
        format.html { redirect_to dispositivos_path, notice: 'Dispositivo was successfully created.' }
        format.json { render :show, status: :created, location: @dispositivo }
      else
        format.html { render :new }
        format.json { render json: @dispositivo.errors, status: :unprocessable_entity }
      end
    end
  end


  def update

    systemlog "update device: #{@dispositivo.nombre}"

    respond_to do |format|
      if @dispositivo.update(dispositivo_params)
        format.html { redirect_to @dispositivo, notice: 'Dispositivo was successfully updated.' }
        format.json { render :show, status: :ok, location: @dispositivo }
      else
        format.html { render :edit }
        format.json { render json: @dispositivo.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @dispositivo.destroy
    systemlog "delete device: #{@dispositivo.nombre}"

    respond_to do |format|
      format.html { redirect_to dispositivos_url, notice: 'Dispositivo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def macroAvailable
    if $macros_global == nil then
      $macros_global=Hash.new

      if (((Dir.pwd.to_s.scan(/public\/macros/))).join.to_s!="public/macros") then
        Dir.chdir "#{Rails.root}/public/macros/"
      end

      Dir.foreach(Dir.pwd) do |file|
        begin
          if file!='..' and file!='.' then
            xml = File.open(file)
            m = Hash.from_xml(xml)
            m=m["Macro"]

            macro= Macro.new m["name"], m["device"]["manufacturer"],
                             m["device"]["serie"], m["device"]["model"]
            inputs=m["inputs"]["input"]
            if inputs!=nil then
              inputs.each do |i|
                macro.insert_input i
              end
            end
            commands=m["commands"]["command"]
            if commands!=nil then
              commands.each do |i|
                macro.insert_command i
              end
            end
            key = macro.nombre
            $macros_global[key.to_sym]= macro

            puts $macros_global

          end
        rescue => e

          File.delete file
        end

      end


    end
    device=current_user.dispositivos.find(params[:id])
    @macrosAvailables=Hash.new


    $macros_global.each do |key, macro|
      if macro.fabricante == device.fabricante then
        @macrosAvailables[key]=macro
      end
    end
    @dispositivo=device

  end

  def goMacro

    @dispositivo=current_user.dispositivos.find(params[:d])
    @macro = $macros_global[params[:m].to_sym]

  end



  def runMacro
    parame= params["/dispositivos/runMacro"]
    puts parame
    @macro=$macros_global[parame[:macro].to_sym]
    via= parame[:send_by]
    @device=current_user.dispositivos.find(parame[:d])

    puts @device.id
    puts @device.nombre
    puts @device.fabricante

    @sentenciasFinales=Array.new


    @macro.commands.each do |c|
      comando=c

      @macro.inputs.each do |i|
        valor=parame[i.to_sym]
        comando = comando.gsub /#{i}/, valor

      end
      @sentenciasFinales.push comando

    end

    sol= @device.runMacro @macro,via


    systemlog "Run macro #{@macro.nombre} in device: #{ @device.nombre} msg: #{sol[:msg]} "

    @sol=sol[:msg]


  end

  def openSSH

    puts @_params

    @d =set_dispositivo
    systemlog "open ssh session: #{@d.nombre}"


    @url="?hostname=#{@d.ip}&username=#{@d.username}&password=#{Base64.encode64(@d.passsh)}"


  end


  def realizaBackup


    dis=current_user.dispositivos.find @_params[:disp]
    tipo =@_params[:tipo]
    via_entra =@_params[:via]
    nom =@_params[:"/dispositivos/realizaBackup"][:nombre]
    systemlog "new backup: #{nom}, device #{dis.nombre}"


    if Dir.exist? "/srv/tftp/#{dis.nombre}" then
      puts "directorio existe"
    else
      Dir.chdir "/srv/tftp/"
      Dir.mkdir dis.nombre
    end

    orden =""
    if tipo == "1" then
      orden = "running-config"
    elsif tipo == "2" then
      orden = "startup-config"
    elsif tipo == "3" then
      orden = "vlan.dat"
    elsif tipo == "4" then
      orden ="total"
    end

    via = ""
####################

#th = Thread.new { Serverftp.new "/tftpboot/#{dis}" }
# Serverftp.new "/tftpboot/#{dis}"
    th = Thread.new { `ruby #{DIRECCIONFTP}/serverftp.rb #{dis.to_s}` }
    dirip = 0
    Socket.getifaddrs.reject { |ifaddr| !ifaddr.addr.ip? || !ifaddr.addr.ipv4? || (ifaddr.flags & Socket::IFF_MULTICAST == 0) }.each do |inte|

      dirip= inte.addr.inspect.scan(/((?:\d{1,3}.){3}(\d{1,3}))/)[0][0] if inte.name == 'eth0'


    end

##############
#server= Thread.new { Serverftp.new "public/devices/#{dis.nombre}" }
    commands=["enable", "copy #{orden} ftp:", "#{dirip}", nom]


#sleep 2
    if via_entra == "1" then
      via = "console"
      send_console dis.id, dis.passenable, commands
    elsif via_entra == "2" then
      send_telnet_ftp dis.id, dis.ip, dis.nombre, dis.passtelnet, dis.telnetport, commands
    elsif via_entra == "3" then
      send_ssh dis.id, dis.ip, dis.nombre, dis.passsh,dis.sshport, commands

    end


    th.terminate

    redirect_to :back
  end

  def recuperaBackup

    dis=current_user.dispositivos.find @_params[:disp]
    tipo =@_params[:tipo]
    via_entra =@_params[:via]
    nom =@_params[:"/dispositivos/recuperaBackup"][:archivo]

    systemlog "recover backup: #{nom}, #{dis.nombre}"


    orden =""
    if tipo == "1" then
      orden = "running-config"
    elsif tipo == "2" then
      orden = "startup-config"
    elsif tipo == "3" then
      orden = "vlan.dat"
    elsif tipo == "4" then
      orden ="total"
    end

    via = ""

    th = Thread.new { `ruby #{DIRECCIONFTP}/serverftp.rb #{dis.to_s}` }
    dirip = 0
    Socket.getifaddrs.reject { |ifaddr| !ifaddr.addr.ip? || !ifaddr.addr.ipv4? || (ifaddr.flags & Socket::IFF_MULTICAST == 0) }.each do |inte|

      dirip= inte.addr.inspect.scan(/((?:\d{1,3}.){3}(\d{1,3}))/)[0][0] if inte.name == 'eth0'


    end

    commands=["enable", "copy ftp: #{orden} ", "#{dirip}", nom,"\n"]

    if via_entra == "1" then
      via = "console"
      send_console dis.id, dis.passenable, commands
    elsif via_entra == "2" then
      send_telnet_ftp dis.id, dis.ip, dis.nombre, dis.passtelnet, dir.telnetport, commands
    elsif via_entra == "3" then
      send_ssh dis.id, dis.ip, dis.nombre, dis.passsh, dir.sshport, commands

    end


    th.terminate

    redirect_to :back

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_dispositivo
    @dispositivo = current_user.dispositivos.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dispositivo_params
    params.require(:dispositivo).permit(:tipo, :fabricante, :serie, :modelo, :nombre, :fecha, :descripcion, :ip, :passenable, :passtelnet, :telnetport, :passsh, :sshport, :consoleconfig, :username)
  end



  def send_telnet_ftp id, ip, user, pass, port, commands
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



end
