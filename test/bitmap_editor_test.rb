require_relative 'helper'

Protest.describe 'BitmapEditor' do
  setup do
    @editor = BitmapEditor.new
  end

  context '.execute_command!' do
    context 'I' do
      test 'validates there is no bitmap created' do
        attach_bitmap(@editor)

        assert_raise(RuntimeError) { @editor.execute_command!('I', []) }
      end

      test 'accepts only 2 arguments' do
        assert_error_message(ArgumentError, /^Wrong number of arguments .* expected 2/) do
          @editor.execute_command!('I', [])
        end
      end

      test 'creates a new bitmap' do
        refute @editor.instance_variable_get(:@bitmap)

        @editor.execute_command!('I', ['3', '3'])

        assert @editor.instance_variable_get(:@bitmap)
      end
    end

    context 'C' do
      test 'validates bitmap presence' do
        assert_raise(RuntimeError) { @editor.execute_command!('C', []) }
      end

      test 'validates no arguments passed' do
        attach_bitmap(@editor)

        assert_error_message(ArgumentError, /^Wrong number of arguments .* expected 0/) do
          @editor.execute_command!('C', ['1'])
        end
      end

      test 'erase the bitmap' do
        bitmap = attach_bitmap(@editor)
        @editor.execute_command!('C', [])

        assert_equal 'O', bitmap[1, 1]
        assert_equal 'O', bitmap[1, 2]
        assert_equal 'O', bitmap[2, 1]
        assert_equal 'O', bitmap[2, 2]
      end
    end

    context 'L' do
      test 'validates bitmap presence' do
        assert_raise(RuntimeError) { @editor.execute_command!('L', []) }
      end

      test 'accepts only 3 arguments' do
        attach_bitmap(@editor)

        assert_error_message(ArgumentError, /^Wrong number of arguments .* expected 3/) do
          @editor.execute_command!('L', [])
        end
      end

      test 'paint a pixel in the bitmap' do
        bitmap = attach_bitmap(@editor, Bitmap.new(2, 2))

        @editor.execute_command!('L', ['1', '2', 'G'])

        assert_equal 'O', bitmap[1, 1]
        assert_equal 'G', bitmap[1, 2]
        assert_equal 'O', bitmap[2, 1]
        assert_equal 'O', bitmap[2, 2]
      end
    end

    context 'V' do
      test 'validates bitmap presence' do
        assert_raise(RuntimeError) { @editor.execute_command!('V', []) }
      end

      test 'accepts only 4 arguments' do
        attach_bitmap(@editor)

        assert_error_message(ArgumentError, /^Wrong number of arguments .* expected 4/) do
          @editor.execute_command!('V', [])
        end
      end

      test 'draw a vertical segment in the bitmap' do
        bitmap = attach_bitmap(@editor, Bitmap.new(4, 4))

        @editor.execute_command!('V', ['1', '2', '4', 'Z'])
        @editor.execute_command!('V', ['3', '3', '4', 'E'])

        expected =
          "OOOO\n" +
          "ZOOO\n" +
          "ZOEO\n" +
          "ZOEO\n"

        assert_equal expected, bitmap.inspect
      end
    end

    context 'H' do
      test 'validates bitmap presence' do
        assert_raise(RuntimeError) { @editor.execute_command!('H', []) }
      end

      test 'accepts only 4 arguments' do
        attach_bitmap(@editor)

        assert_error_message(ArgumentError, /^Wrong number of arguments .* expected 4/) do
          @editor.execute_command!('H', [])
        end
      end

      test 'draw an horizontal segment in the bitmap' do
        bitmap = attach_bitmap(@editor, Bitmap.new(4, 4))

        @editor.execute_command!('H', ['1', '2', '4', 'Z'])
        @editor.execute_command!('H', ['2', '4', '2', 'E'])

        expected =
          "OOOO\n" +
          "OEEE\n" +
          "OOOO\n" +
          "ZZOO\n"

        assert_equal expected, bitmap.inspect
      end
    end

    context 'S' do
      test 'validates bitmap presence' do
        assert_raise(RuntimeError) { @editor.execute_command!('S', []) }
      end

      test 'validates no arguments passed' do
        attach_bitmap(@editor)

        assert_error_message(ArgumentError, /^Wrong number of arguments .* expected 0/) do
          @editor.execute_command!('S', ['1'])
        end
      end

      test 'prints the bitmap in the screen' do
        bitmap = Bitmap.new(4, 4)
        bitmap.paint!(1, 1, 'D')
        bitmap.paint!(2, 2, 'D')
        bitmap.paint!(3, 3, 'D')
        bitmap.paint!(4, 4, 'D')
        attach_bitmap(@editor, bitmap)

        out, _ = capture_io do
          @editor.execute_command!('S', [])
        end

        expected =
          "DOOO\n" +
          "ODOO\n" +
          "OODO\n" +
          "OOOD\n"

        assert_equal expected, out
      end
    end

    context 'Unknown command' do
      test 'raise an error when receives an unrecognised command' do
        assert_error_message(RuntimeError, /unrecognised command 'W'/) do
          @editor.execute_command!('W', [])
        end
      end
    end

    context 'Invalid arguments' do
      test 'number arguments must be between 1 and 250' do
        assert_error_message(ArgumentError, /Integer '0' out of bounds/) do
          @editor.execute_command!('I', ['0', '12'])
        end

        assert_error_message(ArgumentError, /Integer '251' out of bounds/) do
          @editor.execute_command!('I', ['251', '12'])
        end
      end

      test 'colour arguments must be a capital letter' do
        assert_error_message(RuntimeError, /Parameter unknown: 'a'/) do
          @editor.execute_command!('L', ['2', '1', 'a'])
        end

        assert_error_message(RuntimeError, /Parameter unknown: 'RR'/) do
          @editor.execute_command!('L', ['2', '1', 'RR'])
        end
      end
    end
  end

  context '.run' do
    test 'a correct file is needed' do
      out, _ = capture_io do
        refute @editor.run(nil)
      end

      assert_equal "please provide correct file", out.chomp

      out, _ = capture_io do
        refute @editor.run("/tmp/this/should/not/exist.file")
      end

      assert_equal "please provide correct file", out.chomp
    end

    context 'with an input file with errors' do
      test 'stops execution on unknown command' do
        out, _ = capture_io do
          refute @editor.run("test/fixtures/unknown_command.txt")
        end

        assert out.match(/Error parsing the file in line: 1/)
        assert out.match(/unrecognised command 'W' :\(/)
      end

      test 'stops execution if the order of the commands is incorrect' do
        out, _ = capture_io do
          refute @editor.run("test/fixtures/bad_order_commands.txt")
        end

        assert out.match(/Error parsing the file in line: 1/)
        assert out.match(/Can not execute command 'S' if there is no image created first/)
      end

      test 'stops execution if a command receives wrong arguments' do
        out, _ = capture_io do
          refute @editor.run("test/fixtures/wrong_arguments.txt")
        end

        assert out.match(/invalid column \(line: 2\)/)
      end
    end

    context 'with a valid input file' do
      test 'execute all the commands' do
        out, _ = capture_io do
          assert @editor.run("test/fixtures/valid_input_file.txt")
        end

        assert_equal "OOXOOXOO\nOOXOOXOO\nXXXXXXXX\nOOXKKXOO\nOOXKKXOO\nXXXXXXXX\nOOXOOXOO\nOOXOOXOO\n", out
      end
    end
  end

  private

  def attach_bitmap(editor, bitmap = nil)
    unless bitmap
      bitmap = Bitmap.new(2, 2)
      bitmap.paint!(1, 1, 'R')
    end

    @editor.instance_variable_set :@bitmap, bitmap
  end

  # Taken from minitest library.
  # File 'lib/minitest/assertions.rb', line 395
  def capture_io
    require 'stringio'

    captured_stdout, captured_stderr = StringIO.new, StringIO.new

    orig_stdout, orig_stderr = $stdout, $stderr
    $stdout, $stderr         = captured_stdout, captured_stderr

    yield

    return captured_stdout.string, captured_stderr.string
  ensure
    $stdout = orig_stdout
    $stderr = orig_stderr
  end
end
