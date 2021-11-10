class CryptoMenu
  def menu
    puts "1. Simplified DES"
    puts "2. Simplified AES"
    puts "3. Fast Modular Exponent"
    puts "4. Diffie-Hellman Key Exchange"
    puts "5. ElGamal Encryption"
    puts "Your choice (1..5):"
    c = gets.chomp
    return c.to_i
  end

  def s_des
    require "./crypto/s_des.rb"
    puts "Simplified DES"
    puts "--------------"
    puts
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
    puts "Simplified DES"
    puts "--------------"
    puts
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
    puts
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
    puts
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
    puts
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
end
