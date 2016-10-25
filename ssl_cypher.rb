require 'openssl'
require 'digest/sha2'
require 'base64'

$alg = 'AES-256-CBC'
opt = 1;

while opt != 0
  puts('Do you want to: ')
  puts("\t1) Encrypt a message")
  puts("\t2) Decrypt a message")
  puts("\t0) Exit")
  opt = gets.chomp

  digest = Digest::SHA2.new
  puts "Introduce a key for the encryption\n"

  digest.update(gets.chomp)
  key = digest.digest

  iv = OpenSSL::Cipher::Cipher.new($alg).random_iv

  aes = OpenSSL::Cipher::Cipher.new($alg)
  aes.encrypt
  aes.key = key
  aes.iv = iv

  if opt.equal? 1
    puts "Introduce the text you want to encrypt\n"
    cipher = aes.update(gets.chomp)
    cipher << aes.final

    cipher64 = [cipher].pack('m')
    puts "Encrypted data in base64 --> #{cipher64}"
  elsif opt.equal? 2
    puts "Introduce the text you want to decrypt\n"
    decode_cipher = OpenSSL::Cipher::Cipher.new($alg)
    decode_cipher.decrypt
    decode_cipher.key = key
    decode_cipher.iv = iv
    plain = decode_cipher.update(gets.chomp.unpack('m')[0])
    plain << decode_cipher.final
    puts "Decrypted Text ---> #{plain}"
  end
end
