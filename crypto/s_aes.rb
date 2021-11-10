require "./class/array.rb"
require "./class/string.rb"
require "./class/integer.rb"

class SAes
  attr_accessor :plain, :cipher, :key0, :key1, :key2

  $RCon = [[1,0,0,0, 0,0,0,0], [0,0,1,1, 0,0,0,0]]
  $SBox_enc = [["1001", "0100", "1010", "1011"], ["1101", "0001", "1000", "0101"],
               ["0110", "0010", "0000", "0011"], ["1100", "1110", "1111", "0111"]]
  $SBox_dec = [["1010", "0101", "1001", "1011"], ["0001", "0111", "1000", "1111"],
               ["0110", "0000", "0010", "0011"], ["1100", "0100", "1101", "1110"]]
  $GF_2 = ['0', '2', '4', '6', '8', 'A', 'C', 'E', '3', '1', '7', '5', 'B', '9', 'F', 'D']
  $GF_4 = ['0', '4', '8', 'C', '3', '7', 'B', 'F', '6', '2', 'E', 'A', '5', '1', 'D', '9']
  $GF_9 = ['0', '9', '1', '8', '2', 'B', '3', 'A', '4', 'D', '5', 'C', '6', 'F', '7', 'E']

  def initialize(plaintext, key)
    self.plain = plaintext.to_arr
    self.key0 = key.to_arr
    self.key1 = []
    self.key2 = []
  end

  def encrypt(plain = nil)
    self.plain = plain.to_arr if !plain.nil?
    puts "Plain: #{self.plain.print}"
    puts "Key  : #{self.key0.print}"
    puts
    puts "w#{0.subscript} = #{self.key0[0..7].print}"
    puts "w#{1.subscript} = #{self.key0[8..15].print}"
    puts
    self.key1 = generate_keys(self.key0, 1) if self.key1.empty?
    self.key2 = generate_keys(self.key1, 2) if self.key2.empty?
    puts "Key#{0.subscript} = w#{0.subscript},w#{1.subscript} = #{self.key0.print}"
    puts "Key#{1.subscript} = w#{2.subscript},w#{3.subscript} = #{self.key1.print}"
    puts "Key#{2.subscript} = w#{4.subscript},w#{5.subscript} = #{self.key2.print}"
    puts
    puts "Round 0 = Plain Text XOR Key#{0.subscript}"
    round0 = get_round_key(self.plain, self.key0)
    puts
    puts "Round 1: Nibble Substitution R#{0.subscript}"
    r0_subs = encryption_round(round0)
    puts
    mixed = mixed_columns(r0_subs, 'e')
    puts
    puts "Round 1: Mixed Columns XOR Key#{1.subscript}"
    round1 = get_round_key(mixed, self.key1)
    puts
    puts "Final Round: Nibble Substitution R#{1.subscript}"
    r1_subs = encryption_round(round1)
    puts
    puts "Final Round: Round 1 XOR Key#{2.subscript}"
    self.cipher = get_round_key(r1_subs, self.key2)
    puts
    puts "Cipher Text: #{self.cipher.print}"
  end

  def decrypt(cipher = nil)
    self.cipher = cipher.to_arr if !cipher.nil?
    puts "Cipher: #{self.cipher.print}"
    puts "Key  : #{self.key0.print}"
    puts
    puts "w#{0.subscript} = #{self.key0[0..7].print}"
    puts "w#{1.subscript} = #{self.key0[8..15].print}"
    puts
    self.key1 = generate_keys(self.key0, 1) if self.key1.empty?
    self.key2 = generate_keys(self.key1, 2) if self.key2.empty?
    puts "Key#{0.subscript} = w#{0.subscript},w#{1.subscript} = #{self.key0.print}"
    puts "Key#{1.subscript} = w#{2.subscript},w#{3.subscript} = #{self.key1.print}"
    puts "Key#{2.subscript} = w#{4.subscript},w#{5.subscript} = #{self.key2.print}"
    puts
    puts "Round 2 = Cipher Text XOR Key#{2.subscript}"
    round2 = get_round_key(self.cipher, self.key2)
    puts
    puts "Round 1: Inverse Nibble Substitution R#{2.subscript}"
    r2_subs = decryption_round(round2)
    puts
    puts "Round 1 = Inverse Substitution XOR Key#{1.subscript}"
    round1 = get_round_key(r2_subs, self.key1)
    puts "Round 1: Mixed Columns XOR Key#{1.subscript}"
    mixed = mixed_columns(round1, 'd')
    puts
    puts "Final Round: Nibble Substitution R#{1.subscript}"
    r1_subs = decryption_round(mixed)
    puts
    puts "Final Round: Round 1 XOR Key#{2.subscript}"
    self.plain = get_round_key(r1_subs, self.key0)
    puts
    puts "Plain Text: #{self.plain.print}"
  end

  def generate_keys(key, key_num)
    w1 = key[8..15]
    w2 = get_nibble_key(key, key_num-1)
    w3 = w2.xor(w1)
    puts "w#{(key_num*2+1).subscript} = w#{(key_num*2).subscript} XOR w#{(key_num*2-1).subscript}"
    puts "   = #{w2.print} XOR"
    puts "     #{w1.print}"
    puts "   = #{w3.print}"
    puts
    return w2+w3
  end

  def get_nibble_key(key, idx)
    rotnib = key[12..15] + key[8..11]
    sub_left = substitute_nibble(rotnib[0..1], rotnib[2..3], 'e')
    sub_right = substitute_nibble(rotnib[4..5], rotnib[6..7], 'e')
    sub_nib = (sub_left + sub_right).to_arr
    result = key[0..7].xor($RCon[idx]).xor(sub_nib)
    puts "w#{((idx+1)*2).subscript} = w#{(idx*2).subscript} XOR RCon(#{idx+1}) XOR SubNib(RotNib(w#{(idx*2+1).subscript}))"
    puts "Dimana:"
    puts "RCon(#{idx+1})    = #{$RCon[idx].print} #constant"
    puts "RotNib(w#{(idx*2+1).subscript}) = #{rotnib.print}"
    puts "Jadi w#{((idx+1)*2).subscript}    = #{key[0..7].print} XOR #{$RCon[idx].print} XOR SubNib(#{rotnib.print})"
    puts
    puts "Substitution Nibble (SubNib(#{rotnib.print}))"
    puts "Substitution row: bit1,bit2; Substitution col: bit3,bit4"
    puts "Left Nibble: #{rotnib[0..3].join('')}   -   Right half: #{rotnib[4..7].join('')}"
    puts "Left Row   : #{rotnib[0..1].join('')}     -   Right Row : #{rotnib[4..5].join('')}"
    puts "Left Col   : #{rotnib[2..3].join('')}     -   Right Col : #{rotnib[6..7].join('')}"
    puts "Sub Left   : #{sub_left}   -   Sub Right : #{sub_right}"
    puts "SubNib(#{rotnib.print}) = #{sub_left} #{sub_right}"
    puts
    puts "w#{((idx+1)*2).subscript} = #{key[0..7].print} XOR"
    puts "     #{$RCon[idx].print} XOR"
    puts "     #{sub_nib.print}"
    puts "   = #{result.print}"
    return result
  end

  def get_round_key(text, key)
    result = text.xor(key)
    puts "        = #{text.print} XOR"
    puts "          #{key.print}"
    puts "        = #{result.print}"
    return result
  end

  def encryption_round(round)
    puts "Round: #{round.print}"
    sub_nib=[]
    for idx in 0..3 do
      sub_nib << substitute_nibble(round[idx*4..idx*4+1], round[idx*4+2..idx*4+3], 'e')
      puts "Nibble-#{idx+1}: #{round[idx*4..idx*4+3].join('')}  - Row: #{round[idx*4..idx*4+1].join('')}; Col: #{round[idx*4+2..idx*4+3].join('')} --> Substitution: #{sub_nib[idx]}"
    end
    puts "SubNib(#{round.print}) = #{sub_nib.join(' ')}"
    puts
    puts "Shift Row: Tukar nibble ke-2 dan ke-4"
    result = sub_nib[0]+sub_nib[3]+sub_nib[2]+sub_nib[1]
    puts "Shift: #{sub_nib[0]} #{sub_nib[3]} #{sub_nib[2]} #{sub_nib[1]}"
    return result.to_arr
  end

  def decryption_round(round)
    puts "Shift Row: Tukar nibble ke-2 dan ke-4"
    shift = round[0..3]+round[12..15]+round[8..11]+round[4..7]
    puts
    puts "Inverse Shift Row: #{shift.print}"
    sub_nib=[]
    for idx in 0..3 do
      sub_nib << substitute_nibble(shift[idx*4..idx*4+1], shift[idx*4+2..idx*4+3], 'd')
      puts "Nibble-#{idx+1}: #{shift[idx*4..idx*4+3].join('')}  - Row: #{shift[idx*4..idx*4+1].join('')}; Col: #{shift[idx*4+2..idx*4+3].join('')} --> Substitution: #{sub_nib[idx]}"
    end
    puts "InvSubNib(#{shift.print}) = #{sub_nib.join(' ')}"
    puts
    return sub_nib.join().to_arr
  end

  def mixed_columns(text, type)
    mix = [text[0..3].to_hex, #S(0,0)
           text[4..7].to_hex, #S(1,0)
           text[8..11].to_hex, #S(0,1)
           text[12..15].to_hex] #S(0,0)
    mix2 = []
    mix4 = []
    mix9 = []
    result = []
    if type == 'e'
      mix.each { |m| mix4 << $GF_4[m.to_i(16)] }
      result = [mix[0].to_bit.to_arr.xor(mix4[1].to_bit.to_arr),
                mix4[0].to_bit.to_arr.xor(mix[1].to_bit.to_arr),
                mix[2].to_bit.to_arr.xor(mix4[3].to_bit.to_arr),
                mix4[2].to_bit.to_arr.xor(mix[3].to_bit.to_arr)]
    else
      mix.each do |m|
        mix2 << $GF_2[m.to_i(16)]
        mix9 << $GF_9[m.to_i(16)]
      end
      result = [mix9[0].to_bit.to_arr.xor(mix2[1].to_bit.to_arr),
                mix2[0].to_bit.to_arr.xor(mix9[1].to_bit.to_arr),
                mix9[2].to_bit.to_arr.xor(mix2[3].to_bit.to_arr),
                mix2[2].to_bit.to_arr.xor(mix9[3].to_bit.to_arr)]
    end

    puts "Mixed Columns"
    puts "GF Multiplication table"
    puts "X   0,   1,   2,   3,   4,   5,   6,   7,   8,   9,   A,   B,   C,   D,   E,   F"
    puts "2 #{$GF_2}"
    puts "4 #{$GF_4}"
    puts "9 #{$GF_9}"
    puts
    puts "S' = M x S"
    if type == 'e'
      puts "   = |1 4| |#{text[0..3].join('')} #{text[8..11].join('')}|"
      puts "     |4 1| |#{text[4..7].join('')} #{text[12..15].join('')}|"
      puts
      puts "S'(0,0) = S(0,0) XOR 4S(1,0) = #{text[0..3].join('')} XOR 4x#{text[4..7].join('')} = #{mix[0]} XOR 4x#{mix[1]}"
      puts "        = #{mix[0]} XOR #{mix4[1]} = #{mix[0].to_bit} XOR #{mix4[1].to_bit}"
      puts "        = #{result[0].join('')}"
      puts "S'(1,0) = 4S(0,0) XOR S(1,0) = #{text[0..3].join('')} XOR 4x#{text[4..7].join('')} = 4x#{mix[0]} XOR #{mix[1]}"
      puts "        = #{mix4[0]} XOR #{mix[1]} = #{mix4[0].to_bit} XOR #{mix[1].to_bit}"
      puts "        = #{result[1].join('')}"
      puts "S'(0,1) = S(0,1) XOR 4S(1,1) = #{text[0..3].join('')} XOR 4x#{text[4..7].join('')} = #{mix[0]} XOR 4x#{mix[1]}"
      puts "        = #{mix[0]} XOR #{mix4[1]} = #{mix[0].to_bit} XOR #{mix4[1].to_bit}"
      puts "        = #{result[2].join('')}"
      puts "S'(1,1) = 4S(0,1) XOR S(1,1) = #{text[0..3].join('')} XOR 4x#{text[4..7].join('')} = 4x#{mix[0]} XOR #{mix[1]}"
      puts "        = #{mix4[0]} XOR #{mix[1]} = #{mix4[0].to_bit} XOR #{mix[1].to_bit}"
      puts "        = #{result[3].join('')}"
      puts "S'      = #{result.join('').to_arr.print}"
    else
      puts "   = |9 2| |#{text[0..3].join('')} #{text[8..11].join('')}|"
      puts "     |2 9| |#{text[4..7].join('')} #{text[12..15].join('')}|"
      puts
      puts "S'(0,0) = 9S(0,0) XOR 2S(1,0) = 9x#{text[0..3].join('')} XOR 2x#{text[4..7].join('')} = 9x#{mix[0]} XOR 2x#{mix[1]}"
      puts "        = #{mix9[0]} XOR #{mix2[1]} = #{mix9[0].to_bit} XOR #{mix2[1].to_bit}"
      puts "        = #{result[0].join('')}"
      puts "S'(1,0) = 2S(0,0) XOR 9S(1,0) = 2x#{text[0..3].join('')} XOR 9x#{text[4..7].join('')} = 2x#{mix[0]} XOR 9x#{mix[1]}"
      puts "        = #{mix2[0]} XOR #{mix9[1]} = #{mix2[0].to_bit} XOR #{mix9[1].to_bit}"
      puts "        = #{result[1].join('')}"
      puts "S'(0,1) = 9S(0,1) XOR 2S(1,1) = 9x#{text[0..3].join('')} XOR 2x#{text[4..7].join('')} = 9x#{mix[0]} XOR 2x#{mix[1]}"
      puts "        = #{mix9[0]} XOR #{mix2[1]} = #{mix9[0].to_bit} XOR #{mix2[1].to_bit}"
      puts "        = #{result[2].join('')}"
      puts "S'(1,1) = 2S(0,1) XOR 9S(1,1) = 2x#{text[0..3].join('')} XOR 9x#{text[4..7].join('')} = 2x#{mix[0]} XOR 9x#{mix[1]}"
      puts "        = #{mix2[0]} XOR #{mix9[1]} = #{mix2[0].to_bit} XOR #{mix9[1].to_bit}"
      puts "        = #{result[3].join('')}"
      puts "S'      = #{result.join('').to_arr.print}"
    end
    return result.join('').to_arr
  end

  private
  def substitute_nibble(row, col, type)
    r = row.join('').to_i(2)
    c = col.join('').to_i(2)
    return type == 'e' ? $SBox_enc[r][c] : $SBox_dec[r][c]
  end
end
