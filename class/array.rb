class Array
  def lshift
    [self[1], self[2], self[3], self[4], self[0]]
  end

  def lshift2
    self.lshift.lshift
  end

  def print
    str = ''
    case self.length
    when 4
      str = "#{self[0]}#{self[1]} #{self[2]}#{self[3]}"
    when 8
      str = "#{self[0..3].join('')} #{self[4..7].join('')}"
    when 10
      str = "#{self[0..4].join('')} #{self[5..9].join('')}"
    when 16
      str = "#{self[0..3].join('')} #{self[4..7].join('')} #{self[8..11].join('')} #{self[12..15].join('')}"
    else
      str = "#{self.join('')}"
    end
    return str
  end

  def swap
    sw = self[4..7] + self[0..3]
    puts "Swap   : #{sw.print}"
    puts
    return sw
  end

  def to_hex
    self.join('').to_i(2).to_s(16).upcase
  end

  def xor(ar2)
    result = []
    self.each_with_index do |a, i|
      result[i] = a^ar2[i]
    end
    return result
  end
end
