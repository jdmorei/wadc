require 'ftpd'
require 'thread'
class Serverftp

  attr_accessor :ip

  class Driver

    def initialize(data_dir)
      @user = 'prueba'
      @password= 'prueba'
      @data_dir = data_dir
    end

    def authenticate(user, password)
      if user== 'prueba' and password == 'prueba' then
        true
      else
        false
      end
    end

    def file_system(user)
      a=Ftpd::DiskFileSystem.new(@data_dir)
    end

  end

  def initialize data_dir
    dirip = 0
    Socket.getifaddrs.reject { |ifaddr| !ifaddr.addr.ip? || !ifaddr.addr.ipv4? || (ifaddr.flags & Socket::IFF_MULTICAST == 0) }.each do |inte|

      dirip= inte.addr.inspect.scan(/((?:\d{1,3}.){3}(\d{1,3}))/)[0][0] if inte.name == 'eth0'


    end
    @ip = dirip
    #begin
    puts Dir.pwd
    driver = Driver.new(data_dir)
    server = Ftpd::FtpServer.new(driver)
    server.port = 21
    server.server_name = 'dracsc'
    server.interface = dirip
    server.start
    puts "Server listening on port #{server.bound_port}"
    gets
#    rescue => e

#   end


  end

  def cerrar driver
    driver.close
  end


end

dis = ARGV[0].to_s

#if Dir.exist? "/tftpboot/#{dis}" then
#  puts "directorio existe"
#else
#  Dir.chdir "/tftpboot/"
##  Dir.mkdir dis
#end

Serverftp.new "/tftpboot"
#dirip = 0
#Socket.getifaddrs.reject { |ifaddr| !ifaddr.addr.ip? || !ifaddr.addr.ipv4? || (ifaddr.flags & Socket::IFF_MULTICAST == 0) }.each do |inte|

#  dirip= inte.addr.inspect.scan(/((?:\d{1,3}.){3}(\d{1,3}))/)[0][0] if inte.name == 'eth0'


#end