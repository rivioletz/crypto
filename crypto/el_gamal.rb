require "./class/integer.rb"

class ElGamal
  attr_accessor :base, :modulo, :pr_key, :pub_key1, :pub_key2, :mask_key, :plain, :cipher

  def initialize(base, modulo, key_d, key_i, plain)
    self.base = base.to_i
    self.modulo = modulo.to_i
    self.pr_key = key_d.to_i
    self.mask_key = key_i.to_i
    self.plain = plain.to_i
  end

  def encrypt
    k_beta = set_public_key("beta")
    k_ether = set_public_key("ether")
    k_mask = set_public_key("mask_enc")
    puts "y = x . k_M (mod p)"
    puts "  = #{self.plain} . #{k_mask} (mod #{modulo})"
    puts "  = #{self.plain*k_mask} (mod #{modulo})"
    self.cipher = (self.plain*k_mask) % modulo
    puts "  = #{self.cipher}"
    puts
    puts "Hasil Enkripsi: #{self.cipher}"
    return self.cipher
  end

  def decrypt
    k_mask = set_public_key("mask_dec")
    puts "k_M⁻#{1.superscript} = k_M⁽ᵖ⁻#{2.superscript}⁾ (mod p)"
    puts "   = #{k_mask}#{(self.modulo-2).superscript} (mod #{modulo})"
    k_mask_inv = k_mask.fast_mod(self.modulo-2, self.modulo)
    puts
    puts "x = y . k_M⁻#{1.superscript} (mod p)"
    puts "  = #{self.cipher} . #{k_mask_inv} (mod #{modulo})"
    puts "  = #{self.cipher*k_mask_inv} (mod #{modulo})"
    plain = (self.cipher*k_mask_inv) % modulo
    puts "  = #{plain}"
    puts
    puts "Hasil Dekripsi: #{plain}"
    return plain
  end

  def set_public_key(type)
    result = 0
    case type
    when "beta"
      puts "β = k_pub,B = αᵈ (mod p)"
      puts " = k_pub,B = #{self.base}#{self.pr_key.superscript} (mod #{self.modulo})"
      puts
      result = self.base.fast_mod(self.pr_key, self.modulo)
      self.pub_key1 = result
      puts
    when "ether"
      puts "k_E = k_pub,A = αⁱ (mod p)"
      puts " = k_pub,B = #{self.base}#{self.mask_key.superscript} (mod #{self.modulo})"
      puts
      result = self.base.fast_mod(self.mask_key, self.modulo)
      self.pub_key2 = result
      puts
    when "mask_enc"
      puts "k_M = βⁱ (mod p)"
      puts " = k_pub,B = #{self.pub_key1}#{self.mask_key.superscript} (mod #{self.modulo})"
      puts
      result = self.pub_key1.fast_mod(self.mask_key, self.modulo)
      puts
    when "mask_dec"
      puts "k_M = k_Eᵈ (mod p)"
      puts " = k_pub,B = #{self.pub_key2}#{self.pr_key.superscript} (mod #{self.modulo})"
      puts
      result = self.pub_key2.fast_mod(self.pr_key, self.modulo)
      puts
    end
    return result
  end
end
