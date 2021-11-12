require "./class/point.rb"
require "./class/integer.rb"
require "./crypto/ecc.rb"

class Ecdh
  attr_accessor :point, :a, :b, :modulo, :pr_key1, :pr_key2, :pub_key1, :pub_key2

  def initialize(p, a, b, m, alpha, beta)
    self.point = p
    self.a = a.to_i
    self.b = b.to_i
    self.modulo = m.to_i
    self.pr_key1 = alpha.to_i
    self.pr_key2 = beta.to_i
  end

  def encrypt
    self.generate_key

  end

  def generate_key
    ecc = Ecc.new(self.point, self.a, self.b, self.modulo)
    e = ecc.compute_points
    n = e.length+1
    alpha = self.pr_key1 % n
    beta = self.pr_key2 % n
    self.pub_key1 = e[alpha-1]
    self.pub_key2 = e[beta-1]
    puts "E: y#{2.superscript} ≡ x#{3.superscript} + #{a}x + #{b} (mod #{self.modulo})"

    puts "α = #{self.pr_key1}"
    if alpha != self.pr_key1 then
      puts "A = #{self.pr_key1}G mod (#{n}) ≡ #{alpha}G = #{self.pub_key1}"
    else
      puts "A = #{self.pr_key1}G = #{self.pub_key1}"
    end

    puts "β = #{self.pr_key2}"
    if beta != self.pr_key2 then
      puts "B = #{self.pr_key2}G mod (#{n}) ≡ #{beta}G = #{self.pub_key2}"
    else
      puts "B = #{self.pr_key2}G = #{self.pub_key2}"
    end

    puts
    ba = ((self.pr_key2*alpha) % n)
    ab = ((self.pr_key1*beta) % n)
    puts "Pembuktian:"
    puts "βA = βαG = #{self.pr_key2}(#{alpha})G = #{self.pr_key2*alpha}G = #{ba}G = #{e[ba-1]}"
    puts "αB = αβG = #{self.pr_key1}(#{beta})G = #{self.pr_key1*beta}G = #{ab}G = #{e[ab-1]}"
    return e
  end
end
