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
when 6
  crypto.ecc
when 7
  crypto.ecdh
when 8
  crypto.ds_rsa
when 9
  crypto.ds_elgamal
when 10
  crypto.ds_ecc
else
  puts "Wrong choice"
end
