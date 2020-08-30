require 'builder'

class MacrosController < ApplicationController
  $macros_global=Hash.new
  def crear

    if @_params==nil then

    else

      macro = Macro.new  params[:"/macros/crear"][:nombre],
                         params[:"/macros/crear"][:fabricante],
                         params[:"/macros/crear"][:serie],
                         params[:"/macros/crear"][:modelo],
                         params[:"/macros/crear"][:osversion],
                         params[:"/macros/crear"][:version],
                         params[:"/macros/crear"][:via],
                         params[:"/macros/crear"][:icon]

      num_inputs=params[:"/macros/crear"][:num_inputs]
      num_commands=params[:"/macros/crear"][:num_commands]

      aux =1
      salir=0
      num_inputs.to_i.times do |n|

        while salir< num_inputs.to_i do

          inp="input#{aux}"
          puts "es el input #{aux}"
          if((params[:"/macros/crear"][inp.to_sym]) == nil) then
            #puts "vacio  #{aux}"
          else
            macro.insert_input params[:"/macros/crear"][inp.to_sym]
            salir+=1
          end
          aux+=1

        end

      end
      aux =1
      salir=0
      num_commands.to_i.times do |n|

        while salir< num_commands.to_i do

          inp="command#{aux}"
          #puts "es el command #{aux}"
          if((params[:"/macros/crear"][inp.to_sym]) == nil) then
            #puts "vacio  #{aux}"
          else
            macro.insert_command params[:"/macros/crear"][inp.to_sym]
            salir+=1
          end
          aux+=1

        end

      end

      macro.commands.each do |c|

        if $macros_global[c.to_sym]!=nil then

          ma = $macros_global[c.to_sym]
          ma.inputs.each do |i_m|
            macro.insert_input i_m
          end

          ma.commands.each do |i_c|
            macro.insert_command i_c
          end
          macro.commands.delete c
        end


      end
      puts  ######################

      puts  macro.to_s

      puts  ######################
      macro.to_xml
      systemlog "create macro: #{macro.nombre}"

      redirect_to macros_consultar_path

    end
  end

  def importar
    if params[:"/macros/importar"]== nil then
      puts params[:"/macros/importar"]
      flash[:alert] = "No ha seleccionado un archivo válido"
      #redirect_to macros_importar_url, flash: { error: "No ha seleccionado un archivo válido" }

    else

      begin

        macro = Macro.new

        uploaded_io = params[:"/macros/importar"][:importar]

        nombre = uploaded_io.original_filename.scan(/(^.*)\.\w*$/).join

        File.open(Rails.root.join('public', 'macros', "Import_#{nombre}.xml"), 'wb') do |file|
          text=uploaded_io.read
          text=text.gsub /<name>(.*)<\/name>/ ,  "<name>Import_#{nombre}</name>"
          text=text.gsub /<!--.*-->/ ,  ""
          text=text.gsub /(<\?xml.*?>)/ ,  ""

          file.write(text)
        end
        xml= File.new  "#{Rails.root}/public/macros/Import_#{nombre}.xml"
        macro.xml_to_macro xml
        systemlog "import macro: #{macro.nombre}"

        redirect_to macros_consultar_path

      rescue  => e
        flash[:alert] = e
      end
      end
  end

  def actualizar
    if params[:m] != nil then

      idMacro= params[:m]
      m = $macros_global[idMacro.to_sym]
      @macro=m
    else if params[:"/macros/actualizar"]!= nil

           macro = Macro.new  params[:"/macros/actualizar"][:nombre],
                              params[:"/macros/actualizar"][:fabricante],
                              params[:"/macros/actualizar"][:serie],
                              params[:"/macros/actualizar"][:modelo],
                              params[:"/macros/actualizar"][:osversion],
                              params[:"/macros/actualizar"][:version],
                              params[:"/macros/actualizar"][:via],
                              params[:"/macros/actualizar"][:icon]

           num_inputs=params[:"/macros/actualizar"][:num_inputs]
           num_commands=params[:"/macros/actualizar"][:num_commands]

           aux =0
           salir=0
           #num_inputs.to_i.times do |n|

             while salir< num_inputs.to_i do
               puts "cadena con #{aux}----#{salir}---"
               inp="input#{aux}"
              # puts "es el input #{aux}"
               if((params[:"/macros/actualizar"][inp.to_sym]) == nil) then
                 #puts "vacio  #{aux}"
               else
                 macro.insert_input params[:"/macros/actualizar"][inp.to_sym]
                 salir+=1
               end
               aux+=1

            # end

           end
           aux =0
           salir=0
          # num_commands.to_i.times do |n|

             while salir< num_commands.to_i do

               inp="command#{aux}"
               puts "es el command #{aux}"
               if((params[:"/macros/actualizar"][inp.to_sym]) == nil) then
                 #puts "vacio  #{aux}"
               else
                 macro.insert_command params[:"/macros/actualizar"][inp.to_sym]
                 salir+=1
               end
               aux+=1

             end

         #  end

           macro.commands.each do |c|

             if $macros_global[c.to_sym]!=nil then

               ma=$macros_global[c.to_sym]
               ma.inputs.each do |i_m|
                 macro.insert_input i_m
               end

               ma.commands.each do |i_c|
                 macro.insert_command i_c
               end
               macro.commands.delete c

             end


           end
           puts  macro.to_s
           macro.to_xml



           systemlog "update macro: #{macro.nombre}"

           redirect_to macros_consultar_path

         end

    end

  end

  def consultar

    $macros_global=Hash.new

   # if (((Dir.pwd.to_s.scan(/public\/macros/))).join.to_s!="#{Rails.root}/public/macros")  then
      Dir.chdir "#{Rails.root}/public/macros/"
   # end

      Dir.foreach(Dir.pwd) do |file|
        begin
        if file!='..' and file!='.' then
          xml = File.open( file )
          m = Hash.from_xml(xml)
          m=m["Macro"]

        #  print "###########################3\n"

       #   print m
      # #   print "###########################3\n"

          macro= Macro.new m["name"],
                           m["device"]["manufacturer"],
                           m["device"]["serie"],
                           m["device"]["model"],
                           m["device"]["osversion"],
                           m["version"],
                           m["via"],
                           m["icon"]

          inputs=m["inputs"]["input"]

          if inputs!=nil then
            if !inputs.instance_of? String
              inputs.each do |i|
                macro.insert_input i
              end
            else
              macro.insert_input inputs
            end
          end

          commands=m["commands"]["command"]

          if commands!=nil then
            if !commands.instance_of? String
              commands.each do |i|
                macro.insert_command i
              end
            else
              macro.insert_command commands
            end

          end
          key = macro.nombre
          $macros_global[key.to_sym]= macro


        end
        rescue => e
          puts "Se ha eliminado porque #{e}"
         # File.delete file
      end

      end

  end

  def exportar
    send_file(
        "#{Rails.root}/public/macros/#{params['m']}.xml",
        type: "application/xml"
    )
    systemlog "export macro: #{params['m']}"

  end

  def clonar

    if (((Dir.pwd.to_s.scan(/public\/macros/))).join.to_s!="public/macros")  then
      Dir.chdir "public/macros/"
    end
    macro=$macros_global[params["m"].to_sym]
    nombre_original=macro.nombre
    nombre_nuevo="#{nombre_original}_copy"
    macro.nombre=nombre_nuevo
    $macros_global[nombre_nuevo.to_sym]=macro
    macro.to_xml
    systemlog "clone macro: #{macro.nombre}}"

    redirect_to macros_consultar_path

  end

  def eliminar
    File.delete("#{Rails.root}/public/macros/#{params['m']}.xml")
    systemlog "delete macro: #{params['m']}"

    redirect_to macros_consultar_path
  end

  def quick

    self.discoverMacros

    @devices = current_user.dispositivos.all


    render  template: macros_quick_path, :locals=> { devices: @devices } ,  layout: false
  end

  def runQuick

   # begin
      macroParam = params[:macro]
      deviceIdParam = params[:idDev]
      deviceNameParam = params[:namDev]

      @macro = $macros_global[macroParam.to_sym]
      @device = Dispositivo.find(deviceIdParam)


      if @macro && @device

        result= @device.runMacro @macro


      else

          result={status:'error', msg:'Macro or Device doesn\'t exist'}

      end


      systemlog "Info: run macro #{@macro.nombre} in device: #{ @device.nombre} msg: #{result[:msg]} "

      if(result[:status]=='success')

        render json:{status: 'success', msg: t('msg_success_run'),sub: t('msg_generic_sub_success_run'), footer: t('msg_generic_footer')}

      else

        render json:{status: 'error', msg: t('msg_generic_error_run'),sub: t('msg_generic_sub_error_run'), footer: t('msg_generic_footer')}

      end


  end


  def checkMacroName

    name64 = params.require(:name)
    macro64 = params.require(:macro)

    name = Base64.decode64(name64)
    macro = JSON.parse(Base64.decode64(macro64))

    self.discoverMacros

    if $macros_global[name.to_sym]  then


      render json:{ 'error': 'El nombre de la macro ya existe' }, status: 400

    else

      inputs=[]
      commands=[]


      newMacro=Macro.new(name, macro["manufacturer"], macro["os_version"],macro["manufacturer"],macro["os_version"],macro["version"], nil, nil)

      inputs =  JSON.parse(macro["inputs"])
      inputs = macro["inputs"] if inputs==nil

      if inputs!=nil then
        if !inputs.instance_of? String
          inputs.each do |i|

            newMacro.insert_input i if !(i.instance_of? Integer)
          end
        else
          newMacro.insert_input inputs
        end
      end

      commands=JSON.parse(macro["outputs"])
      commands = macro["outputs"] if commands==nil

      if commands!=nil then
        if !commands.instance_of? String
          commands.each do |i|
            newMacro.insert_command i if !(i.instance_of? Integer)
          end
        else
          newMacro.insert_command commands
        end

      end
      key = newMacro.nombre
      $macros_global[key.to_sym]= newMacro

      newMacro.to_xml
       systemlog "import from repo macro: #{newMacro.nombre}"

      # render json:{status: 'success', msg: newMacro.to_json,sub: 'newMacro', footer: t('msg_generic_footer')}
      render json:{ status: 'success', msg: "#{newMacro.nombre}" }, status: 201

    end




  end

  def discoverMacros
    $macros_global=Hash.new

    # if (((Dir.pwd.to_s.scan(/public\/macros/))).join.to_s!="#{Rails.root}/public/macros")  then
    Dir.chdir "#{Rails.root}/public/macros/"
    # end

    Dir.foreach(Dir.pwd) do |file|
      begin
        if file!='..' and file!='.' then
          xml = File.open( file )
          m = Hash.from_xml(xml)
          m=m["Macro"]

          macro= Macro.new m["name"],
                           m["device"]["manufacturer"],
                           m["device"]["serie"],
                           m["device"]["model"],
                           m["device"]["osversion"],
                           m["version"],
                           m["via"],
                           m["icon"]

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
          # puts macro

          #puts $macros_global[key.to_sym]

        end
      rescue => e
        puts "Se ha eliminado porque #{e}"
        File.delete file
      end

    end

  end

end
