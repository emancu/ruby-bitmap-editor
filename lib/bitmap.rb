class Bitmap
  def initialize(m, n)
    @bitmap = Array.new(n){ Array.new(m, 'O') }
    @row_count = n
    @column_count = m
  end

  def clear!
    @bitmap.each { |row| row.map!{'O'} }
  end

  def paint!(x, y, colour)
    assert_valid_column!(x)
    assert_valid_row!(y)

    @bitmap[y-1][x-1] = colour
  end

  def draw_vertical!(x, y1, y2, colour)
    assert_valid_column!(x)
    assert_valid_row!(y1)
    assert_valid_row!(y2)
    assert_valid_segment!(y1, y2)

    (y1..y2).each do |i|
      @bitmap[i-1][x-1] = colour
    end
  end

  def draw_horizontal!(x1, x2, y, colour)
    assert_valid_column!(x1)
    assert_valid_column!(x2)
    assert_valid_segment!(x1, x2)
    assert_valid_row!(y)

    row = @bitmap[y-1]

    (x1..x2).each do |j|
      row[j-1] = colour
    end
  end

  def inspect
    str = ""

    @bitmap.each do |row|
      str += row.join("")
      str += "\n"
    end

    str
  end

  def [](c, r)
    assert_valid_column!(c)
    assert_valid_row!(r)

    @bitmap[r-1][c-1]
  end

  private

  def assert_valid_column!(c)
    fail ArgumentError.new("invalid column") unless c.between?(1, @column_count)
  end

  def assert_valid_row!(r)
    fail ArgumentError.new("invalid row") unless r.between?(1, @row_count)
  end

  def assert_valid_segment!(start, stop)
    fail ArgumentError.new("invalid segment") if (start..stop).to_a.empty?
  end
end
