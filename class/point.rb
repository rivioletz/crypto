class Point
  attr_accessor :x, :y

  def initialize(point_x = 0, point_y = 0)
    self.x = point_x.to_i
    self.y = point_y.to_i
  end

  def equals(point)
    self.x == point.x && self.y == point.y
  end

  def substract_point(point)
    Point.new(self.x - point.x, self.y - point.y)
  end

  def add_x(point)
    #return nil if self.x == point.x # P+Q = Infinite if Xp = Xq
    self.x + point.x
  end

  def add_y(point)
    #return nil if self.equals(point) && self.y == 0 # P+P = Infinite if Yp = 0
    self.y + point.y
  end

  def substract_x(point)
    self.x - point.x
  end

  def substract_y(point)
    self.y - point.y
  end

  def to_s
    return "(#{self.x},#{self.y})"
  end
end
