require 'openssl'
require 'digest/sha2'
require 'base64'

class POO_ssl_cipher

  $alg = 'AES-256-CBC'
  $key, $iv, $key64, $cipher64 = nil

  def initialize
    opt = 1
    vector_gen
    while opt != 0
      puts 'Select an option:'
      puts "\t1) Encrypt a text"
      puts "\t2) Decrypt a text"
      puts "\t0) Exit"

      opt = gets.chomp.to_i

      if $key.nil?
        key_gen
        key_to_base64
      end

      if opt.equal? 1
        encrypt
      elsif opt.equal? 2
        puts "Introduce the text you want to decrypt\n"
        decrypt(gets.chomp)
      end
    end
  end

  def key_gen
    puts 'Introduce the key for the encryption'
    digest = Digest::SHA2.new
    digest.update(gets.chomp)
    $key = digest.digest
  end

  def vector_gen
    $iv = OpenSSL::Cipher::Cipher.new($alg).random_iv
  end

  def key_to_base64
    $key64 = [$key].pack('m')
    puts "Key in base64: #{$key64}\n"
    puts (('*****')*6)
  end

  def encrypt
    aes = OpenSSL::Cipher::Cipher.new($alg)
    aes.encrypt
    aes.key = $key
    aes.iv = $iv

    puts 'Introduce the text you want to encrypt'
    cipher = aes.update(gets.chomp)
    cipher << aes.final

    $cipher64 = [cipher].pack('m')
    puts "The encrypted data in base64--->\n\n"
    puts "#{$cipher64}"
    puts (('*****')*6)
  end

  def decrypt(cipher64)
    decode_cipher = OpenSSL::Cipher::Cipher.new($alg)
    decode_cipher.decrypt
    decode_cipher.key = $key
    decode_cipher.iv = $iv
    begin
      plain = decode_cipher.update(cipher64.unpack('m')[0])
      plain << decode_cipher.final
    rescue Exception => msg
      puts "Error ocurred: #{msg}\n"
      puts (('*****')*6)
      initialize
    end
    puts "Decrypted text---> \n"
    puts plain
    puts (('*****')*6)
  end
end

POO_ssl_cipher.new

