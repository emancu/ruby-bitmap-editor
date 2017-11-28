require_relative 'bitmap'

class BitmapEditor
  def initialize
    @bitmap = nil
  end

  def run(file)
    if file.nil? || !File.exists?(file)
      puts "please provide correct file"
      return
    end

    File.open(file).each_line.with_index(1) do |line, line_number|
      begin
        command, *args = line.chomp.split(" ")

        execute_command!(command, args)
      rescue ArgumentError => error
        puts "#{error.message} (line: #{line_number})"
        return
      rescue RuntimeError => error
        puts "Error parsing the file in line: #{line_number}", error.message
        return
      end
    end

    true
  end

  def execute_command!(command, args)
    sanitize_and_validate_arguments!(args)

    case command
    when 'I'
      fail "Image already created!" if @bitmap
      validate_arguments_size(command, args, 2)

      @bitmap = Bitmap.new(*args)
    when 'C'
      validate_bitmap_presence(command)
      validate_arguments_size(command, args, 0)

      @bitmap.clear!
    when 'L'
      validate_bitmap_presence(command)
      validate_arguments_size(command, args, 3)

      @bitmap.paint!(*args)
    when 'V'
      validate_bitmap_presence(command)
      validate_arguments_size(command, args, 4)

      @bitmap.draw_vertical!(*args)
    when 'H'
      validate_bitmap_presence(command)
      validate_arguments_size(command, args, 4)

      @bitmap.draw_horizontal!(*args)
    when 'S'
      validate_bitmap_presence(command)
      validate_arguments_size(command, args, 0)

      puts @bitmap.inspect
    else
      fail "unrecognised command '#{command}' :("
    end
  end

  private

  def sanitize_and_validate_arguments!(args)
    args.map! do |arg|
      if /^[A-Z]$/.match(arg) # Is a colour!
        arg
      elsif /^\d{1,3}$/.match(arg)
        value = Integer(arg)

        if value.between?(1, 250)
          value
        else
          fail ArgumentError.new("Integer '#{value}' out of bounds")
        end
      else
        fail "Parameter unknown: '#{arg}'"
      end
    end
  end

  def validate_bitmap_presence(command)
    fail "Can not execute command '#{command}' if there is no image created first" unless @bitmap
  end

  def validate_arguments_size(command, args, n)
    if args.size != n
      fail ArgumentError.new("Wrong number of arguments for command '#{command}' (given #{args.size}, expected #{n})")
    end
  end
end
