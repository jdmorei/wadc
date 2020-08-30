class Macro < ActiveRecord::Base
  attr_accessor :nombre,:fabricante,:serie,:modelo,:inputs, :commands, :version,:via, :osversion, :icono



  def initialize (nom=nil,fab=nil,seri=nil,model=nil,os_ver=nil,ver=nil,v=nil,ico=nil)
    @nombre=nom
    @fabricante=fab
    @version= ver
    @via = v
    @serie=seri
    @osversion= os_ver
    @modelo=model
    @icono=ico
    @inputs=Array.new
    @commands=Array.new
  end

  def insert_input (input)
    @inputs.push input
  end

  def insert_command (command)
    @commands.push command
  end

  def to_xml
    puts "hola hoala"
    xml = ::Builder::XmlMarkup.new( :indent => 2 )
    puts xml.Macro {
      xml.name @nombre
      xml.version @version
      xml.via @via
      xml.icon @icono
      xml.device{
        xml.manufacturer @fabricante
        xml.serie @serie
        xml.model @modelo
        xml.osversion @osversion

      }
      xml.inputs {
        if @inputs.empty?!=true then
          @inputs.each do |i|
            xml.input i
          end
        end
      }
      xml.commands {
        if @commands.empty?!=true then
          @commands.each do |i|
            xml.command i
          end
        end
      }
    }

    xml_data = xml.target!

    if (((Dir.pwd.to_s.scan(/public\/macros/))).join.to_s!="public/macros")  then
      Dir.chdir "public/macros/"
    end
    file = File.new("#{@nombre}.xml", "wb")
    file.write(xml_data)
    file.close

  end

  def xml_to_macro (file)
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

    return  macro
  end


  def to_s

    result ="MACRO: \n nombre: #{@nombre} \n version: #{@version} \n icono: #{@icono} \n via: #{via} fabricante: #{@fabricante} \n serie: #{@serie} \n modelo: #{@modelo} \n osversion: #{osversion}
 \n INPUTS:\n"

    if @inputs.empty?!=true then
      @inputs.each do |i|
          result << "\t#{i.to_s}\n"
      end
    end

    result << "\n COMMANDS: \n "

    if @commands.empty?!=true then
      @commands.each do |i|
        result << "\t#{i.to_s}\n"
      end
    end

    return result
  end


end
