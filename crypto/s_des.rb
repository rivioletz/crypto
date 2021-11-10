require "./class/array.rb"
require "./class/string.rb"
require "./class/integer.rb"

class SDes
  attr_accessor :plain, :cipher, :key, :key1, :key2
  attr_reader :S0, :S1

  $S0 = [["01", "00", "11", "10"], ["11", "10", "01", "00"], ["00", "10", "01", "11"], ["11", "01", "11", "10"]]
  $S1 = [["00", "01", "10", "11"], ["10", "00", "01", "11"], ["11", "00", "01", "00"], ["10", "01", "00", "11"]]

  def initialize(plaintext, key1, key2 = nil)
    self.plain = plaintext.to_arr
    if key2.nil? or key2.empty?
      self.key = key1.to_arr
      self.key1 = []
      self.key2 = []
    else
      self.key = []
      self.key1 = key1.to_arr
      self.key2 = key2.to_arr
    end
  end

  def encrypt(plain = nil)
    generate_keys(self.key) if self.key2.empty?
    puts
    puts "Plain: #{self.plain.print}"
    puts "Key#{10.subscript}: #{self.key.print}" if !self.key.nil?
    puts "Key#{1.subscript} : #{self.key1.print}" if !self.key.nil?
    puts "Key#{2.subscript} : #{self.key2.print}" if !self.key.nil?
    puts
    ip = permutation_initial(plain.nil? ? self.plain : plain.to_arr)
    puts
    fk1 = encryption_round(ip, self.key1)
    puts "Output putaran pertama: #{fk1.print}"
    fk2 = encryption_round(fk1.swap, self.key2)
    puts
    self.cipher = permutation_final(fk2)
    puts "Hasil akhir Cipher: #{self.cipher.print}"
  end

  def decrypt(cipher = nil)
    generate_keys(self.key) if !self.key.empty?
    puts
    ip = permutation_initial(cipher.nil? ? self.cipher : cipher.to_arr)
    puts
    fk1 = encryption_round(ip, self.key2)
    puts "Output putaran pertama: #{fk1.print}"
    fk2 = encryption_round(fk1.swap, self.key1)
    puts
    self.plain = permutation_final(fk2)
    puts "Hasil akhir Plain: #{self.plain.print}"
  end

  def encryption_round(ip, key)
    ep = permutation_expansion(ip[4..7], key)
    puts
    sb = substitute_boxes(ep)
    p4 = permutation_p4(sb)
    puts
    concatenate_ip(ip, p4, (key == self.key1) ? 1 : 2)
  end

  def generate_keys(k)
    puts "Key Generation"
    puts "P#{10.subscript} Permutation"
    p5l = [k[2], k[4], k[1], k[6], k[3]]
    p5r = [k[9], k[0], k[8], k[7], k[5]]
    puts "Bit: 12345 67890"
    puts "Key: #{self.key.print}"
    puts "Bit: 35274 01986"
    puts "P#{10.subscript}: #{(p5l+p5r).print}"
    p5l_ls1 = p5l.lshift
    p5r_ls1 = p5r.lshift
    self.key1 = [p5r_ls1[0], p5l_ls1[2], p5r_ls1[1], p5l_ls1[3], p5r_ls1[2], p5l_ls1[4], p5r_ls1[4], p5r_ls1[3]]
    p5l_ls2 = p5l_ls1.lshift2
    p5r_ls2 = p5r_ls1.lshift2
    self.key2 = [p5r_ls2[0], p5l_ls2[2], p5r_ls2[1], p5l_ls2[3], p5r_ls2[2], p5l_ls2[4], p5r_ls2[4], p5r_ls2[3]]
    puts
    puts "P#{10.subscript} Left Shift 1"
    puts "Bit : 12345 67890"
    puts "P#{8.subscript}L#{1.subscript}: #{(p5l_ls1+p5r_ls1).print}"
    puts "Key#{1.subscript}: #{self.key1.print}"
    puts
    puts "P#{10.subscript} Left Shift 2"
    puts "Bit : 12345 67890"
    puts "P#{8.subscript}L#{2.subscript}: #{(p5l_ls2+p5r_ls2).print}"
    puts "Key#{2.subscript}: #{self.key2.print}"
  end

  def permutation_initial(p)
    ip = [p[1], p[5], p[2], p[0], p[3], p[7], p[4], p[6]]
    puts "Initial Permutation"
    puts "Bit  : 1234 5678"
    puts "P    : #{p.print}"
    puts "Bit  : 2631 4857"
    puts "IP(P): #{ip.print}"
    return ip
  end

  def permutation_expansion(ipr, key)
    result = []
    ep = [ipr[3], ipr[0], ipr[1], ipr[2], ipr[1], ipr[2], ipr[3], ipr[0]]
    ep_key = ep.xor(key)
    puts "Expansion/Permutation Right nibble (4-bit) of IP"
    puts "Bit : 4123 2341"
    puts "EPr : #{ep.print}"
    puts "Key#{(key == self.key1) ? "1" : "2"}: #{key.print}"
    puts "XOR : #{ep_key.print}"
    return ep_key
  end

  def permutation_final(f)
    ip_1 = [f[3], f[0], f[2], f[4], f[6], f[1], f[7], f[5]]
    puts "Final Permutation"
    puts "Bit  : 1234 5678"
    puts "P    : #{f.print}"
    puts "Bit  : 4135 7286"
    puts "IP(P): #{ip_1.print}"
    return ip_1
  end

  def substitute_boxes(ep)
    left_row = ep[0].to_s + ep[3].to_s
    left_col = ep[1].to_s + ep[2].to_s
    right_row = ep[4].to_s + ep[7].to_s
    right_col = ep[5].to_s + ep[6].to_s
    s0 = $S0[left_row.to_i(2)][left_col.to_i(2)]
    s1 = $S1[right_row.to_i(2)][right_col.to_i(2)]
    puts "Substitution Boxes"
    puts "Substitution row: bit1,bit4; Substitution col: bit2,bit3"
    puts "Left half: #{ep[0..3].join('')}   -   Right half: #{ep[4..7].join('')}"
    puts "Left Row : #{left_row}     -   Right Row : #{right_row}"
    puts "Left Col : #{left_col}     -   Right Col : #{right_col}"
    puts "S#{0.subscript}'      : #{s0}     -   S#{1.subscript}'       : #{s1}"
    puts "S-Boxes  : #{s0+s1}"
    return (s0+s1).to_arr
  end

  def permutation_p4(sb)
    p4 = [sb[1], sb[3], sb[2], sb[0]]
    puts "Bit      : 2431"
    puts "P#{4.subscript}       : #{p4.join('')}"
    return p4
  end

  def concatenate_ip(ip, p4, num)
    fk_left = p4.xor(ip[0..3])
    fk1 = fk_left + ip[4..7]
    puts "Left half of IP (4-bit)"
    puts "P#{4.subscript}      : #{p4.join('')}"
    puts "IP Left : #{ip[0..3].join('')}"
    puts "XOR     : #{fk_left.join('')}"
    puts "IP Right:      #{ip[4..7].join('')}"
    puts "FK#{num.subscript}     : #{fk1.print}"
    return fk1
  end

end
