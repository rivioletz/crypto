class String
  def to_bit
    self.to_i(16).to_s(2).rjust(4,'0')
  end

  def to_arr
    arr=[]
    self.each_char{ |c| arr << c.to_i if c=='0' || c=='1'}
    return arr
  end
end
