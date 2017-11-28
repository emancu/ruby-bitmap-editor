class Bitmap
  # The technical test describes a MxN Matrix. Usually M is rows and N columns,
  # however in the example I can see that M represents the columns and N the rows.
  def initialize(m, n)
    @bitmap = Array.new(n){ Array.new(m, 'O') }
  end

  def clear!
    @bitmap.each { |row| row.map!{'O'} }
  end

  # 1 <= x, y <= 250 ; colour a signle char
  def paint!(x, y, colour)
    @bitmap[y-1][x-1] = colour
  end

  #TODO: Check numbers are inside the matrix
  def draw_vertical!(x, y1, y2, colour)
    (y1..y2).each do |i|
      @bitmap[i-1][x-1] = colour
    end
  end

  def draw_horizontal!(x1, x2, y, colour)
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
    @bitmap[r-1][c-1]
  end
end
