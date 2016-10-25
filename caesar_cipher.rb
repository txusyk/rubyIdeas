class Caesar_cipher
  def initialize
    opt = 1
    string_ciphered, shift = nil

    puts("\n\t\t Welcome to CAESAR CIPHER in Ruby\n\n")

    while opt != 0
      puts('Do you want to: ')
      puts("\t1) Encrypt a message")
      puts("\t2) Decrypt a message")
      puts("\t0) Exit")
      opt = gets.chomp.to_i

      if opt==1
        puts 'Introduce the string you want to encrypt'
        string = gets.chomp
        puts('-----'*6)

        puts 'Introduce the number of positions you want to shift: '
        shift = gets.chomp.to_i

        puts("\nThe shift KEY is : #{shift}")

        string_ciphered = caesar_cipher_encrypt(string, shift)

        puts ("\n*** Encrypted message is : #{string_ciphered} ***\n\n")
        puts ('*****'*6)
      elsif opt ==2
        puts 'Do you want to print the string you encrypted before? (Y/n)'
        if gets.chomp != 'n'
          puts "\nThe decrypted text is:  #{caesar_cipher_decrypt(string_ciphered, shift)}\n\n"
        else
          puts "\nIntroduce the string you want to decrypt\n"
          string = gets.chomp
          puts('-----'*6)

          puts ('Introduce the number of positions you want to shift: ')
          shift = gets.chomp.to_i

          puts ("\n#{caesar_cipher_decrypt(string, shift)}\n\n")
          puts ('*****'*6)
        end
      end
    end
  end


  def caesar_cipher_encrypt(string, shift)
    alpha = ('a'..'z').to_a
    alpha_big = ('A'..'Z').to_a
    new_string = ''

    string.split(//).each do |letter|

      if alpha.include? letter
        new_letter = letter_shift(letter, alpha, shift)
      elsif alpha_big.include? letter
        new_letter = letter_shift(letter, alpha_big, shift)
      else
        new_letter = letter
      end
      new_string += new_letter
    end
    new_string
  end

  def caesar_cipher_decrypt(string, shift)
    caesar_cipher_encrypt(string, 0-shift)
  end

  def letter_shift(letter, array, shift)
    index = array.index(letter)
    new_index = (index + shift)%(array.length)
    array[new_index]
  end
end

Caesar_cipher.new
