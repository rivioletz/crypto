class CryptoMenu
  def menu
    menu_arr = []
    menu_arr << "Simplified DES"
    menu_arr << "Simplified AES"
    menu_arr << "Fast Modular Exponent"
    menu_arr << "Diffie-Hellman Key Exchange"
    menu_arr << "ElGamal Encryption"
    menu_arr << "Elliptic Curve Encryption"
    menu_arr << "Elliptic Curve Diffie-Hellman"
    menu_arr.each_with_index do |m, i|
      puts "#{i+1}. #{m}"
    end
    puts "Your choice (1..#{menu_arr.length}):"
    c = gets.chomp
    puts
    return c.to_i
  end

  def s_des
    require "./crypto/s_des.rb"
    puts "Simplified DES"
    puts "--------------"
    puts "Enter 8-bit Plaintext P:"
    p = gets.chomp
    puts "Enter 10-bit key K or 8-bit Key-1:"
    k = gets.chomp
    if k.length == 8 then
      puts "Enter 8-bit Key-2 for previous 8-bit Key1:"
      k2 = gets.chomp
    end
    sdes = SDes.new(p, k, k2)
    sdes.encrypt()
    puts
    sdes.decrypt()
  end

  def s_aes
    require "./crypto/s_aes.rb"
    puts "Simplified AES"
    puts "--------------"
    puts "Enter 16-bit Plaintext P:"
    p = gets.chomp
    puts "Enter 16-bit key K:"
    k = gets.chomp
    saes = SAes.new(p, k)
    saes.encrypt()
    puts
    saes.decrypt()
  end

  def exp_mod
    require "./class/integer.rb"
    puts "Fast Modular Exponent"
    puts "---------------------"
    puts "Enter Base:"
    b = gets.chomp
    puts "Enter Exponent:"
    e = gets.chomp
    puts "Enter Modulo:"
    m = gets.chomp
    # m = "467"
    puts
    puts "Result"
    b.to_i.fast_mod(e.to_i, m.to_i)
  end

  def dhke
    require "./crypto/dhke.rb"
    puts "Diffie-Hellman Key Exchange"
    puts "---------------------------"
    puts "Enter Base (alpha):"
    alpha = gets.chomp
    puts "Enter modulo P:"
    p = gets.chomp
    puts "Key A:"
    a = gets.chomp
    puts "Key B:"
    b = gets.chomp
    dhke = Dhke.new(alpha, p, a, b)
    dhke.public_key
    puts
    dhke.common_key
  end

  def elgamal
    require "./crypto/el_gamal.rb"
    puts "ElGamal Encryption"
    puts "------------------"
    puts "Enter Base (alpha):"
    alpha = gets.chomp
    puts "Enter modulo P:"
    p = gets.chomp
    puts "Enter private key d:"
    d = gets.chomp
    puts "Enter intermediate key i:"
    i = gets.chomp
    puts "Enter plaintext x:"
    x = gets.chomp
    elgamal = ElGamal.new(alpha, p, d, i, x)
    elgamal.encrypt
    puts
    elgamal.decrypt
  end

  def ecc
    require "./crypto/ecc.rb"
    require "./class/point.rb"
    puts "Elliptic Curve Encryption"
    puts "-------------------------"
    puts "Enter modulo > 3:"
    m = gets.chomp
    puts "Enter coordinate Px:"
    px = gets.chomp
    puts "Enter coordinate Py:"
    py = gets.chomp
    puts "Enter value a:"
    a = gets.chomp
    puts "Enter value b:"
    b = gets.chomp
    ecc = Ecc.new(Point.new(px, py), a, b, m)
    puts
    loop do
      puts "Elliptic Curve Encryption Submenu"
      puts "---------------------------------"
      menu = ecc.menu
      case menu
      when 1
        ecc.curve_check
      when 2
        puts "Enter coordinate Qx:"
        qx = gets.chomp
        puts "Enter coordinate Qy:"
        qy = gets.chomp
        ecc.add(Point.new(qx, qy))
      when 3
        ecc.compute_points
      end

      puts
      if (menu <= 0) || (menu >=4)
        puts "Wrong choice"
        break
      end
    end
  end

  def ecdh
    require "./crypto/ecdh.rb"
    require "./class/point.rb"
    puts "Elliptic Curve Diffie-Hellman"
    puts "-----------------------------"
    puts "Enter modulo > 3:"
    m = gets.chomp
    puts "Enter coordinate Gx:"
    px = gets.chomp
    puts "Enter coordinate Gy:"
    py = gets.chomp
    puts "Enter value a:"
    a = gets.chomp
    puts "Enter value b:"
    b = gets.chomp
    puts "Enter Base (alpha):"
    alpha = gets.chomp
    puts "Enter Base (beta):"
    beta = gets.chomp
    puts
    ecdh = Ecdh.new(Point.new(px, py), a, b, m, alpha, beta)
    puts
    ecdh.encrypt
    puts
    # ecdh.decrypt
  end
end
