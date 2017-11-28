require 'matrix'

class Bitmap
  # The technical test describes a MxN Matrix. Usually M is rows and N columns,
  # however in the example I can see that M represents the columns and N the rows.
  def initialize(m, n)
    @bitmap = Matrix.build(n, m) {'O'}
  end

  def clear!
    @bitmap = @bitmap.map{'O'}
  end

  # 1 <= x, y <= 250 ; colour a signle char
  def paint!(x, y, colour)
    update_value!(@bitmap.row(x-1), y-1, colour)
  end

  #TODO: Check numbers are inside the matrix
  def draw_vertical!(x, y1, y2, colour)
    column = @bitmap.column(x-1)

    (y1..y2).each {|i| update_value!(column, i-1, colour) }
  end

  def draw_horizontal!(y, x1, x2, colour)
    row = @bitmap.row(y-1)

    (x1..x2).each {|j| update_value!(row, j-1, colour) }
  end

  def inspect
    str = ""

    @bitmap.to_a.each do |row|
      str += row.join("")
      str += "\n"
    end

    str
  end

  def [](i, j)
    @bitmap[i-1, j-1]
  end

  private

  # I don't want to open the Matrix class and monket-patch it.
  # However, my own representation knows well the implementation of the `matrix` class.
  def update_value!(vector, index, new_value)
    vector.send :[]=, index, new_value
  end
end
