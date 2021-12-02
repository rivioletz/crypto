require "./crypto/discrete_log.rb"

class DigitalSignature
  attr_accessor :dlp

  def initialize(b, e, m)
    self.dlp = DiscreteLog.new(b,e,m)
  end

  def valid_rsa?(s)
    sig = self.dlp.new_with_base(s)
    puts "x' ≡ sᵉ (mod n)"
    puts "x' ≡ #{sig}"
    x1 = sig.fast_mod
    puts
    puts "x' ≡ x (mod n)"
    puts "x' ≡ #{self.dlp.base} (mod #{self.dlp.modulo})"
    x2 = self.dlp.base % self.dlp.modulo
    puts "x' ≡ #{x2} (mod #{self.dlp.modulo})"
    puts
    result = x1 == x2
    if result
      puts "sᵉ (mod n) ≡ x (mod n)"
      puts "#{x1} (mod #{self.dlp.modulo}) ≡ #{x2} (mod #{self.dlp.modulo}) --> VALID!"
    else
      puts "sᵉ (mod n) ≡/ x (mod n)"
      puts "#{x1} (mod #{self.dlp.modulo}) ≡/ #{x2} (mod #{self.dlp.modulo}) --> INVALID!"
    end
    return result
  end
end
