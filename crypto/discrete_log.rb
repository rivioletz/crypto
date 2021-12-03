require "./class/array.rb"
require "./class/integer.rb"
require "./class/string.rb"

class DiscreteLog
  attr_accessor :base, :exponent, :modulo, :congruent

  def initialize(b, e, m)
    self.base = b.to_i
    self.exponent = e.to_i
    self.modulo = m.to_i
  end

  def fast_mod
    self.base.fast_mod(self.exponent, self.modulo)
  end

  def inverse
    self.base(self.modulo-2, self.modulo)
  end

  def new_with_base(base)
    DiscreteLog.new(base, self.exponent, self.modulo)
  end

  def basic_mod
    result = self.base % self.modulo
    puts "#{self.base} (mod #{self.modulo}) ≡ #{result}"
    return result
  end

  def to_s
    return "#{self.base}#{self.exponent.superscript} (mod #{self.modulo})"
  end
end
