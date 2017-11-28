require_relative 'helper'

Protest.describe 'Bitmap' do
  context '.new' do
    test 'creates a new bitmap with a canvas in white' do
      bitmap = Bitmap.new(2, 3)

      assert_equal 'O', bitmap[1, 1]
      assert_equal 'O', bitmap[1, 2]
      assert_equal 'O', bitmap[1, 3]
      assert_equal 'O', bitmap[2, 1]
      assert_equal 'O', bitmap[2, 2]
      assert_equal 'O', bitmap[2, 3]
    end
  end

  context '.paint!' do
    test 'it paints a single pixel in the bitmap' do
      bitmap = Bitmap.new(2, 2)

      assert_equal 'O', bitmap[1, 1]
      assert_equal 'O', bitmap[1, 2]
      assert_equal 'O', bitmap[2, 1]
      assert_equal 'O', bitmap[2, 2]

      bitmap.paint!(2, 1, 'R')

      assert_equal 'O', bitmap[1, 1]
      assert_equal 'O', bitmap[1, 2]
      assert_equal 'R', bitmap[2, 1]
      assert_equal 'O', bitmap[2, 2]
    end

    test 'raise an error if the coordinates are out of the limits' do
      bitmap = Bitmap.new(2, 3)

      assert_raise(ArgumentError, "invalid row") {    bitmap.paint!(1, 5, 'R') }
      assert_raise(ArgumentError, "invalid column") { bitmap.paint!(5, 1, 'R') }
      assert_raise(ArgumentError, "invalid column") { bitmap.paint!(5, 5, 'R') }
      assert_raise(ArgumentError, "invalid column") { bitmap.paint!(0,-2, 'R') }
    end
  end

  context '.clear!' do
    test 'resets all the colours to white' do
      bitmap = Bitmap.new(2, 2)

      bitmap.paint!(1, 1, 'R')
      bitmap.paint!(1, 2, 'R')
      bitmap.paint!(2, 1, 'R')
      bitmap.paint!(2, 2, 'R')

      bitmap.clear!

      assert_equal 'O', bitmap[1, 1]
      assert_equal 'O', bitmap[1, 2]
      assert_equal 'O', bitmap[2, 1]
      assert_equal 'O', bitmap[2, 2]
    end
  end

  context '.draw_vertical!' do
    test 'paints a segment on a column between two rows' do
      bitmap = Bitmap.new(2, 5)

      bitmap.draw_vertical!(1, 1, 5, 'R')
      bitmap.draw_vertical!(2, 2, 4, 'Y')

      assert_equal 'R', bitmap[1, 1]
      assert_equal 'R', bitmap[1, 2]
      assert_equal 'R', bitmap[1, 3]
      assert_equal 'R', bitmap[1, 4]
      assert_equal 'R', bitmap[1, 5]

      assert_equal 'O', bitmap[2, 1]
      assert_equal 'Y', bitmap[2, 2]
      assert_equal 'Y', bitmap[2, 3]
      assert_equal 'Y', bitmap[2, 4]
      assert_equal 'O', bitmap[2, 5]
    end

    test 'raise an error when the column or rows are out of bounds' do
      bitmap = Bitmap.new(2, 3)

      assert_raise(ArgumentError, "invalid column") { bitmap.draw_vertical!(5, 1, 1, 'R') }
      assert_raise(ArgumentError, "invalid row") {    bitmap.draw_vertical!(1, 5, 1, 'R') }
      assert_raise(ArgumentError, "invalid row") {    bitmap.draw_vertical!(1, 1, 5, 'R') }
      assert_raise(ArgumentError, "invalid column") { bitmap.draw_vertical!(0,-2, 9, 'R') }
    end

    test 'raise an error when the segment described is empty' do
      bitmap = Bitmap.new(5, 5)

      assert_raise(ArgumentError, "invalid segment") { bitmap.draw_vertical!(1, 4, 2, 'R') }
    end
  end

  context '.draw_horizontal!' do
    test 'paints a segment on a row between two columns' do
      bitmap = Bitmap.new(5, 2)

      bitmap.draw_horizontal!(1, 5, 1, 'R')
      bitmap.draw_horizontal!(2, 4, 2, 'Y')

      assert_equal 'R', bitmap[1, 1]
      assert_equal 'R', bitmap[2, 1]
      assert_equal 'R', bitmap[3, 1]
      assert_equal 'R', bitmap[4, 1]
      assert_equal 'R', bitmap[5, 1]

      assert_equal 'O', bitmap[1, 2]
      assert_equal 'Y', bitmap[2, 2]
      assert_equal 'Y', bitmap[3, 2]
      assert_equal 'Y', bitmap[4, 2]
      assert_equal 'O', bitmap[5, 2]
    end

    test 'raise an error when the column or rows are out of bounds' do
      bitmap = Bitmap.new(2, 3)

      assert_raise(ArgumentError, "invalid column") { bitmap.draw_horizontal!(5, 1, 1, 'R') }
      assert_raise(ArgumentError, "invalid column") { bitmap.draw_horizontal!(1, 5, 1, 'R') }
      assert_raise(ArgumentError, "invalid row") {    bitmap.draw_horizontal!(1, 1, 5, 'R') }
      assert_raise(ArgumentError, "invalid column") { bitmap.draw_horizontal!(0,-2, 9, 'R') }
    end

    test 'raise an error when the segment described is empty' do
      bitmap = Bitmap.new(5, 5)

      assert_raise(ArgumentError, "invalid segment") { bitmap.draw_horizontal!(4, 1, 2, 'R') }
    end
  end

  context '[]' do
    test 'returns the colour of the given pixel' do
      bitmap = Bitmap.new(2, 2)

      assert_equal 'O', bitmap[1, 2]
    end

    test 'raise an error if the pixel is out of bounds' do
      bitmap = Bitmap.new(2, 2)

      assert_raise(ArgumentError, "invalid row") {    bitmap[1, 5] }
      assert_raise(ArgumentError, "invalid column") { bitmap[5, 1] }
      assert_raise(ArgumentError, "invalid column") { bitmap[5, 5] }
    end
  end

  context '.inspect' do
    test 'represents the bitmap with a string' do
      square_bitmap = Bitmap.new(2, 2)
      bitmap = Bitmap.new(5, 6)

      square_bitmap.paint!(1, 1, 'R')
      square_bitmap.paint!(1, 2, 'Y')
      bitmap.paint!(1, 3, 'A')
      bitmap.draw_vertical!(2, 3, 6, 'W')
      bitmap.draw_horizontal!(3, 5, 2, 'Z')

      square_bitmap_expected =
        "RO\n" +
        "YO\n"

      bitmap_expected =
        "OOOOO\n" +
        "OOZZZ\n" +
        "AWOOO\n" +
        "OWOOO\n" +
        "OWOOO\n" +
        "OWOOO\n"

      assert_equal square_bitmap_expected, square_bitmap.inspect
      assert_equal bitmap_expected, bitmap.inspect
    end
  end
end
