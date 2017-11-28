require_relative 'bitmap'

class BitmapEditor
  def initialize
    @bitmap = nil
  end

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    File.open(file).each_line.with_index(1) do |line, line_number|
      begin
        command, *args = line.chomp.split(" ")
        sanitize_and_validate_arguments!(args)

        execute_command!(command, args)
      rescue RuntimeError => error
        puts "Error parsing the file in line: #{line_number}", error.message
        exit 1
      end
    end
  end

  def execute_command!(command, args)
    case command
    when 'I'
      validate_arguments_size(command, args, 2)

      # What happens if you create more than one image? Error or ignore?
      @bitmap ||= Bitmap.new(*args)
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
          fail "Integer '#{value}' out of bounds"
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
      fail "Wrong number of arguments for command '#{command}' (given #{args.size}, expected #{n})"
    end
  end
end
