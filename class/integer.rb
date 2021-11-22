require "./class/array.rb"
require "./class/string.rb"

class Integer
  def fast_mod(exponent, modulo)
    exponent_base2 = exponent.to_s(2)
    result = []
    result[0] = []
    result[1] = exponent_base2.to_arr
    result[2] = []
    puts "#{self}^#{exponent}₍#{10.subscript}₎ = #{self}^#{exponent_base2}₍#{2.subscript}₎"
    sqr_mul_result(multiply(square(result, modulo)), modulo)
  end

  def inverse(modulo)
    self.fast_mod(modulo-2, modulo)
  end

  def square(arr, modulo)
    puts
    puts "Square:"
    exp=0
    kuadrat = self
    (arr[1].length-1).downto(0) do |i|
      arr[0][i] = 2**(exp)
      arr[2][i] = (exp == 0) ? (kuadrat % modulo) : (kuadrat**2) % modulo
      puts "#{arr[1][i]}: #{self}#{arr[0][i].superscript} (mod #{modulo}) ≡ #{kuadrat}#{2.superscript if exp > 0} (mod #{modulo}) = #{arr[2][i]}"
      kuadrat = arr[2][i]
      exp+=1
    end
    return arr
  end

  def multiply(arr)
    puts
    puts "Multiply result bit 1:"
    tmp = 1
    flag = 0
    multi = []
    arr[1].each_with_index do |r,i|
      if r == 1
        tmp *= arr[2][i]
        flag+=1
        multi << tmp if flag == 2
      end
      multi << tmp if flag == 1
      tmp = 1
      flag = 0
    end
    return multi
  end

  def sqr_mul_result(multi, modulo)
    res_mod = 1
    (0..multi.length-1).each do |m|
      tmp_mod = res_mod * multi[0]
      res_mod = tmp_mod % modulo
      multi.shift
      if multi.length == 0 then
        puts "≡ #{tmp_mod} (mod #{modulo})"
        puts "≡ #{res_mod} (mod #{modulo})" if tmp_mod != res_mod
      else
        puts "≡ #{tmp_mod} . #{multi.join(' . ')} (mod #{modulo})"
        puts "≡ #{res_mod} . #{multi.join(' . ')} (mod #{modulo})"  if tmp_mod != res_mod
      end
    end
    return res_mod
  end

  def superscript
    script('super')
  end

  def subscript
    script('sub')
  end

  private
  def script(type)
    text = (type=='super') ? "⁰¹²³⁴⁵⁶⁷⁸⁹" : "₀₁₂₃₄₅₆₇₈₉"
    script_arr = text.split('')
    angka = self.to_s.split('')
    tmp = []
    angka.each do |a|
      tmp << script_arr[a.to_i]
    end
    return tmp.join('')
  end
end
