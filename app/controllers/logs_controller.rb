class LogsController < ApplicationController



  def showLogs
    sal =Array.new
    Dir.chdir "#{Rails.configuration.logs_path}"
    Dir.foreach(Dir.pwd) do |file|
      if file!='..' and file!='.' then
        f = File.new "#{Rails.configuration.logs_path}#{file}"

        l = Logsystem.new f.mtime.to_s, f.size.to_s, file
        sal<<l
      end
    end
    @logs = sal


  end

  def readLog
    logName= params['l']

    #file ="#{Rails.configuration.logs_path}#{logName}"
    milog = Logsystem.new logName
    @logName=milog.name

    @body=milog.readLastAndGrep

  end

  def downloadLog
    send_file(
        "#{Rails.configuration.logs_path}#{params['l']}",
        type: "application/xml"
    )
  end


  def shutdown
    #puts "SHUTDOWNNN"
    `sudo shutdown -h now`
  end

  def help

  end


end
