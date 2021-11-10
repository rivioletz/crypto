require "./crypto/crypto_menu.rb"

crypto = CryptoMenu.new
puts
case crypto.menu
when 1
  crypto.s_des
when 2
  crypto.s_aes
when 3
  crypto.exp_mod
when 4
  crypto.dhke
when 5
  crypto.elgamal
else
  puts "Wrong choice"
end