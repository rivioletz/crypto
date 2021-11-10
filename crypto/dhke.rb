require "./class/integer.rb"

class Dhke
  attr_accessor :base, :modulo, :pr_key1, :pr_key2, :pub_key1, :pub_key2

  def initialize(base, modulo, key_a, key_b)
    self.base = base.to_i
    self.modulo = modulo.to_i
    self.pr_key1 = key_a.to_i
    self.pr_key2 = key_b.to_i
  end

  def public_key
    puts "A = k_pub,A = αᵃ (mod p)"
    puts "  = k_pub,A = #{self.base}#{self.pr_key1.superscript} (mod #{self.modulo})"
    puts
    self.pub_key1 = self.base.fast_mod(self.pr_key1, self.modulo)
    puts
    puts "B = k_pub,B = αᵇ (mod p)"
    puts "  = k_pub,B = #{self.base}#{self.pr_key1.superscript} (mod #{self.modulo})"
    puts
    self.pub_key2 = self.base.fast_mod(self.pr_key2, self.modulo)
    puts
    puts "Public Key:"
    result = "A = #{self.pub_key1}; B = #{self.pub_key2}"
    puts result
    puts
    return result
  end

  def common_key
    puts "Dengan diketahui A = #{self.pub_key1}:"
    puts "k_AB = Aᵇ (mod p)"
    puts "   = #{self.pub_key1}#{self.pr_key2.superscript} (mod #{self.modulo})"
    puts
    common1 = self.pub_key1.fast_mod(self.pr_key2, self.modulo)
    puts
    puts "Dengan diketahui B = #{self.pub_key2}:"
    puts "k_AB = Bᵃ (mod p)"
    puts "   = #{self.pub_key2}#{self.pr_key1.superscript} (mod #{self.modulo})"
    puts
    common2 = self.pub_key2.fast_mod(self.pr_key1, self.modulo)
    puts
    puts "Common key = #{common1}" if common1 == common2
    puts
  end
end
