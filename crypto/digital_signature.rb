require "./crypto/discrete_log.rb"

class DigitalSignature
  attr_accessor :dlp

  def initialize(b, e, m)
    self.dlp = DiscreteLog.new(b.to_i,e.to_i,m.to_i)
  end

  def valid_rsa?(s)
    sig = self.dlp.new_with_base(s)
    puts "x' ≡ sᵉ (mod n)"
    puts "x' ≡ #{sig}"
    x1 = sig.fast_mod
    puts
    puts "x' ≡ x (mod n)"
    puts "x' ≡ #{self.dlp.base} (mod #{self.dlp.modulo})"
    x2 = self.dlp.basic_mod
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

  def self.valid_elgamal?(modulo, alpha, beta, plain, ephemeral, signature)
    require "./crypto/el_gamal.rb"
    puts "t ≡ β^r . r^s (mod p)"
    puts "t = #{beta}#{ephemeral.superscript} . #{ephemeral}#{signature.superscript} (mod #{modulo})"
    puts
    puts "#{beta}#{ephemeral.superscript} (mod #{modulo})"
    t_beta = DiscreteLog.new(beta, ephemeral, modulo)
    t_beta_eq = t_beta.fast_mod
    puts "#{ephemeral}#{signature.superscript} (mod #{modulo})"
    t_rand = DiscreteLog.new(ephemeral, signature, modulo)
    t_rand_eq = t_rand.fast_mod
    t1_eq = t_beta_eq * t_rand_eq
    t1 = t1_eq % modulo
    t_alpha = DiscreteLog.new(alpha, plain, modulo)
    t2 = t_alpha.fast_mod
    puts
    puts "t ≡ #{t_beta_eq} . #{t_rand_eq} (mod #{modulo}) = #{t1_eq} (mod #{modulo})"
    puts "t ≡ #{t1} (mod #{modulo})"
    puts
    puts "t ≡ α^x (mod p)"
    puts "t ≡ #{alpha}#{plain.superscript} (mod #{modulo}) ≡ #{t2} (mod #{modulo})"

    result = t1 == t2
    if result
      puts "β^r . r^s (mod p) ≡ α^x (mod p)"
      puts "#{t1} (mod #{modulo}) ≡ #{t2} (mod #{modulo}) --> VALID!"
    else
      puts "β^r . r^s (mod p) ≡/ α^x (mod p)"
      puts "#{t1} (mod #{modulo}) ≡/ #{t2} (mod #{modulo}) --> INVALID!"
    end
    return result
  end

  def self.valid_ecc?(p, a, b, q, pa, pb, x, r, s)
    require "./crypto/ecc.rb"
    w = s.inverse(q)
    u1 = (w*x) % q
    u2 = (w*r) % q
    e1 = Ecc.new(pa, a, b, p)
    p1 = e1.multiply(u1)
    e2 = Ecc.new(pb, a, b, p)
    p2 = e2.multiply(u2)
    e_total = Ecc.new(p1, a, b, p)
    p_total = e_total.add(p2)
    puts "w ≡ s⁻#{1.superscript} (mod q)"
    puts "w ≡ #{s}⁻#{1.superscript} (mod #{q}) ≡ #{w} (mod #{q})"
    puts
    puts "u#{1.subscript} ≡ w . h(x) (mod q)"
    puts "u#{1.subscript} ≡ #{w} . #{x} (mod #{q})"
    puts "   = #{w * x} (mod #{q}) ≡ #{u1} (mod #{q})"
    puts
    puts "u#{2.subscript} ≡ w . r (mod q)"
    puts "u#{2.subscript} ≡ #{w} . #{r} (mod #{q})"
    puts "   = #{w * r} (mod #{q}) ≡ #{u2} (mod #{q})"
    puts
    puts "P = u#{1.subscript}A + u#{2.subscript}B"
    puts "P = (#{u1} . #{pa}) + (#{u2} . #{pb})"
    puts "P = #{p1} + #{p2} = #{p_total}"
    puts
    
    result = p_total.x == r
    if result
      puts "Px ≡ r (mod q)"
      puts "#{p_total.x} ≡ #{r} (mod #{q}) --> VALID!"
    else
      puts "Px ≡/ r (mod q)"
      puts "#{p_total.x} ≡/ #{r} (mod #{q}) --> INVALID!"
    end
    return result
  end
end
