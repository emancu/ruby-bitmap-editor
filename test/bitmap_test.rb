require_relative 'helper'

class BitmapTest < Minitest::Test

  def test_create_new_instance_with_white_colour
    bitmap = Bitmap.new(2, 3)

    assert_equal 'O', bitmap[1, 1]
    assert_equal 'O', bitmap[1, 2]
    assert_equal 'O', bitmap[1, 3]
    assert_equal 'O', bitmap[2, 1]
    assert_equal 'O', bitmap[2, 2]
    assert_equal 'O', bitmap[2, 3]
  end

  def test_paint_a_single_pixel
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

  def test_clear_bitmap_resets_all_the_colours_to_white
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

  def test_draw_vertical_paints_a_segment_on_column_between_two_rows
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

  def test_draw_horizontal_paints_a_segment_on_row_between_two_columns
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

  def test_pixel_accesor_returns_the_colour_in_the_desired_pixel
    bitmap = Bitmap.new(2, 2)

    # TODO: Test boundaries
    assert_equal 'O', bitmap[1, 2]
  end

  def test_inspect_returns_a_representation_of_the_bitmap
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
