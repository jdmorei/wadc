class SshController < ApplicationController
  def terminal
    if params[:id]!=nil then

      puts params[:id]

      @hostname = "192.168.56.101"
      @username = "wifree"
      @password = "wifree"
      @cmd = params[:id]

      # s=`ssh #{username}@#{@hostname}`

      begin

        shell = {} #this will save the open channel so that we can use it accross threads
        threads = []
# the shell thread
        threads << Thread.new do
          # Connect to the server
          Net::SSH.start(@hostname, @username, :password => @password) do |session|
            # Open an ssh channel
            session.open_channel do |channel|
              # send a shell request, this will open an interactive shell to the server
              channel.send_channel_request "shell" do |ch, success|
                if success
                  # Save the channel to be used in the other thread to send commands
                  shell[:ch] = ch
                  # Register a data event
                  # this will be triggered whenever there is data(output) from the server
                  ch.on_data do |ch, data|
                    puts data
                  end
                end
              end
            end
          end
        end

# the commands thread
        threads << Thread.new do
          loop do
            # This will prompt for a command in the terminal
            print ">"
            cmd = gets
            # Here you've to make sure that cmd ends with '\n'
            # since in this example the cmd is got from the user it ends with
            #a trailing eol
            shell[:ch].send_data cmd
            # exit if the user enters the exit command
            break if cmd == "exit\n"
          end
        end

        threads.each(&:join)
        #ssh = Net::SSH.start(@hostname, @username, :password => @password)
        # res= ssh.send_data "#{@cmd.to_s}\n"
        #puts "****************************"
        #puts "manda comando #{@cmd.to_s}"
        #puts "****************************"
        #res = ssh.exec!(@cmd.to_s)
        #ssh.close
        #respond_to do |format|
        #  format.html { render text: res, status: 200}
          #  format.json { render json: @prueba, status: 200}
        #end
       # puts res
      rescue
        puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
      end
    end

  end
end
