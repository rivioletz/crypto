require "./class/point.rb"
require "./class/integer.rb"

class Ecc
  attr_accessor :point, :a, :b, :modulo

  def initialize(p, a, b, m)
    self.point = p
    self.a = a.to_i
    self.b = b.to_i
    self.modulo = m.to_i
  end

  def curve_check
    puts "Condition: 4a#{3.superscript}+27b#{2.superscript} ≠ 0 mod p"
    puts " = 4.#{self.a}#{3.superscript} + 27.#{self.b}#{2.superscript} (mod #{self.modulo})"
    puts " = 4.#{self.a**3} + 27.#{self.b**2} (mod #{self.modulo})"
    a4 = 4*(self.a**3)
    b27 = 27*(self.b**2)
    a4mod = a4 % self.modulo
    b27mod = b27 % self.modulo

    puts " = #{a4} . #{b27} (mod #{self.modulo}) ≡ #{a4mod} . #{b27mod} (mod #{self.modulo})"
    ab = a4mod * b27mod
    hasil = ab % self.modulo
    puts " ≡ #{ab} (mod #{self.modulo}) ≡ #{hasil} (mod #{self.modulo})"
    status = hasil != 0
    puts "Condition: #{status ? "Valid" : "Invalid"}"
    puts
    return status
  end

  def add(point2)
    s = 0
    if self.point.equals(point2)
      puts "P#{self.point} = Q#{point2}"
      puts "s = (3x#{1.subscript}#{2.superscript} + a) / 2y#{1.subscript} (mod #{self.modulo})"
      puts "  = (3.#{self.point.x}#{2.superscript} + #{self.a})(2y#{1.subscript})⁻#{1.superscript} (mod #{self.modulo})"
      puts "  = (3.#{self.point.x**2} + #{self.a})(2.#{self.point.y})⁻#{1.superscript} (mod #{self.modulo})"
      puts "  = (#{3*(self.point.x**2)} + #{self.a}) . #{2*self.point.y}⁻#{1.superscript} (mod #{self.modulo})"

      x = 3*(self.point.x**2) + self.a
      y = 2*self.point.y
      puts "  = #{x} . #{y}⁻#{1.superscript} (mod #{self.modulo})"
      inv_y = y.fast_mod(modulo-2, modulo)
      puts "  = #{x} . #{inv_y} (mod #{self.modulo})"
      s = (x * inv_y) % modulo
      puts "s ≡ #{s} (mod #{modulo})"
    else
      sub_p = self.point.substract_point(point2)
      inv_x = sub_p.x.fast_mod(modulo-2, modulo)
      s = (sub_p.y * inv_x) % modulo

      puts "P#{self.point} ≠ Q#{point2}"
      puts "s = (y#{2.subscript}-y#{1.subscript}) / (x#{2.subscript}-x#{1.subscript}) (mod #{self.modulo})"
      puts "s = (#{point2.y}-#{self.point.y}) / (#{point2.x}-#{self.point.x}) (mod #{self.modulo})"
      puts "  = #{sub_p.y} . #{sub_p.x}⁻#{1.superscript} (mod #{self.modulo})"
      puts "  = #{sub_p.y} . #{inv_x} (mod #{self.modulo})"
      puts "s ≡ #{s} (mod #{modulo})"
    end

    puts
    x3 = (s**2 - self.point.add_x(point2)) % modulo
    y3 = (s*(self.point.x-x3)-self.point.y) % modulo
    puts "x#{3.subscript} = s#{2.superscript} - x#{1.subscript} - x#{2.subscript} (mod #{modulo})"
    puts "   = #{s}#{2.superscript} - #{self.point.x} - #{point2.x} (mod #{modulo})"
    puts "   = #{s**2} - #{self.point.add_x(point2)} (mod #{modulo})"
    puts "   = #{s**2} - #{self.point.add_x(point2)} (mod #{modulo})"
    puts "   ≡ #{x3} (mod #{modulo})"
    puts

    puts "y#{3.subscript} = s(x#{1.subscript} - x#{3.subscript})-y#{1.subscript} (mod #{modulo})"
    puts "   = #{s}(#{self.point.x} - #{x3})-#{self.point.y} (mod #{modulo})"
    puts "   = #{s}(#{self.point.x - x3})-#{self.point.y} (mod #{modulo})"
    puts "   = #{s*(self.point.x - x3)}-#{self.point.y} (mod #{modulo})"
    puts "   = #{s*(self.point.x - x3)-self.point.y} (mod #{modulo})"
    puts "   ≡ #{y3} (mod #{modulo})"
    puts

    point_add = Point.new(x3,y3)
    puts "Point: #{point_add.to_s}"
    return point_add
  end

  def multiply(num = nil)
    if num.nil?
      compute_points
    else
      p = self.point

      (2..num).each do
        p = self.add(p)
        puts
      end

      return p
    end
  end

  def compute_points
    arr = []
    p = self.point
    inverse = -(self.point.y) % self.modulo
    arr << p

    while ((p.x != self.point.x) || (inverse != (p.y % self.modulo))) do
      p = self.add(p)
      arr << p
      puts
    end

    arr.each_with_index do |a, i|
      puts "P#{(i+1).subscript}: #{a}"
    end

    puts "P#{(arr.length+1).subscript}: θ"
    puts "Jumlah titik: #{arr.length+1}"
    puts
    return arr
  end

  def menu
    menu_arr = []
    menu_arr << "Curve Check"
    menu_arr << "Add Points"
    menu_arr << "Compute Points"

    menu_arr.each_with_index do |m, i|
      puts "#{i+1}. #{m}"
    end
    puts "Your choice (1..#{menu_arr.length}):"
    c = gets.chomp
    puts
    return c.to_i
  end
end
