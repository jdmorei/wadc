class Logsystem
  attr_accessor :date,:name,:size

  def initialize(date=nil, size=nil, name)
    @date = date
    @name = name
    @size = size
  end


  def readLastAndGrep(numLines=true, search=nil)

    result=Array.new

    fd = File.open("#{Rails.configuration.logs_path}#{self.name}","r")

    if File.extname(self.name) == '.gz'

      lines=Array.new

      gz = Zlib::GzipReader.new(fd)

      gz.each_line do |line|

        lines.append line
      end

      pos=lines.length

      loop do

        line= lines[pos]

        if search == nil
          result.append line
        else
          result.append line  if line=~search
        end

        pos=pos-1
        if numLines == true
          if (pos<=0 )
            return result
          end
        else
          if ((lines.length-pos)>=numLines )
            return result
          end
        end


      end

    else

      if numLines== true
        arrayAux=IO.readlines(fd)
      else
        arrayAux=IO.readlines(fd).last(numLines)

      end

        arrayAux.each do |line|

        if search == nil
          result.append line
        else
          result.append line  if line=~search
        end
      end
      return result

    end


  end



end
