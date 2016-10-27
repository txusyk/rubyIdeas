require 'openssl'
require 'digest/sha2'
require 'base64'

class POO_ssl_game_of_life_cypher

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

      puts 'Do you want to use your own key? (Y/n)'

      if gets.chomp == 'y'
        puts 'Introduce your key: '
        $key = gets.chomp
      end

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
    digest = Digest::SHA2.new
    menu
    digest.update($board.display.to_s)
    $key = digest.digest
  end
end

def vector_gen
  $iv = OpenSSL::Cipher::Cipher.new($alg).random_iv
end

def key_to_base64
  $key64 = [$key].pack('m')
  puts "\t\t\tKey in base64: #{$key64}\n"
  puts "\n\t*** Please save this key *** Be careful about sharing it or sharing the details about the configuration you used to generate it"
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

def menu(opt=0)
  while opt != 10
    puts "Introduce the type of element you want to generate\n"
    puts "\t1) Blinker (Size: 3)"
    puts "\t2) Tub (Size: 3)"
    puts "\t3) R-Pentomino (Size: 3)"
    puts "\t4) Glider (Size: 4)"
    puts "\t5) Clock (Size:4)"
    puts "\t6) Lightweight Spaceship (Size:5)"
    puts "\t7) Beehive with tail (Size: 7)"
    puts "\t8) Turtle (Size: 14)"
    puts "\t9) Randomize (You can choose the size)"
    puts '-'*50
    puts "\t10) Exit"
    puts '*'*60+"\n"

    opt = gets.chomp.to_i
    puts

    if opt == 1
      Game.new 'blinker', 3, get_cycles(5), [[1, 0], [1, 1], [1, 2]]
    elsif opt ==2
      Game.new 'tub', 3, get_cycles(5), [[1, 0], [0, 1], [2, 1], [1, 2]]
    elsif opt == 3
      Game.new 'r-pentomino', 3, get_cycles(5), [[1, 0], [2, 0], [0, 1], [1, 1], [1, 2]]
    elsif opt == 4
      Game.new 'glider', 4, get_cycles(10), [[1, 0], [2, 1], [0, 2], [1, 2], [2, 2]]
    elsif opt == 5
      Game.new 'clock', 4, get_cycles(10), [[3, 0], [0, 1], [1, 1], [2, 2], [3, 2], [1, 3]]
    elsif opt== 6
      Game.new 'lightweight spaceship', 5, get_cycles(15), [[1, 0], [2, 0], [3, 0], [4, 0], [0, 1], [4, 1], [4, 2], [0, 3], [3, 3]]
    elsif opt==7
      Game.new 'beehive with tail', 7, get_cycles(20), [[1, 0], [0, 1], [2, 1], [0, 2], [2, 2], [1, 3], [3, 4], [4, 4], [5, 4], [5, 5]]
    elsif opt==8
      Game.new 'turtle', 14, get_cycles(25), [[1, 2], [2, 2], [3, 2], [11, 2], [1, 3], [2, 3], [5, 3], [7, 3], [8, 3], [10, 3], [11, 3], [3, 4], [4, 4], [5, 4], [10, 4], [1, 5], [4, 5], [6, 5], [10, 5], [0, 6], [5, 6], [10, 6], [13, 6], [0, 7], [5, 7], [10, 7], [13, 7], [1, 8], [4, 8], [6, 8], [10, 8], [3, 9], [4, 9], [5, 9], [10, 9], [1, 10], [2, 10], [5, 10], [7, 10], [8, 10], [10, 10], [11, 10], [1, 11], [2, 11], [3, 11], [11, 11]]
    elsif opt==9

      size = get_size(10, 80)

      generation_constant = (size**2)/Random.rand(2..3)
      a = Array.new(generation_constant)

      cont = 0
      while cont < a.size
        a[cont] = [Random.rand(size), Random.rand(size)]
        cont += 1
      end

      Game.new 'random', size, get_cycles(50), a
    else
      puts 'Insert a valid option'
      puts '*'*60+"\n"
    end
    opt = 10
  end
end

def get_size(min, max)
  puts "Choose a limit for the size of the grid (#{min}-#{max})"
  size = gets.chomp.to_i
  if size < min || size > max
    get_size(min, max)
  end
  size
end

def get_cycles(max)
  puts "Choose a limit for the cycles of the  generation (1-#{max})"
  cycles = gets.chomp.to_i
  if cycles < 0 || cycles > max
    get_cycles(max)
  end
  cycles
end

class Game
  def initialize(name, size, generations, initial_life=nil)
    @size = size
    @board = GameBoard.new size, initial_life

    reason = generations.times do |gen|
      @new_board = evolve
      break :all_dead if @new_board.barren?
      break :static if @board == @new_board
    end

    case reason
      when :all_dead then
        puts 'No more life.'
      when :static then
        puts 'No movement.'
      else
        puts 'Specified lifetime ended'
    end
    puts
    $board = @new_board
    $board.display
  end

  def evolve
    life = @board.each_index.select { |i, j| cell_fate(i, j) }
    GameBoard.new @size, life
  end

  def cell_fate(i, j)
    left_right = [0, i-1].max .. [i+1, @size-1].min
    top_bottom = [0, j-1].max .. [j+1, @size-1].min
    sum = 0
    left_right.each { |x|
      top_bottom.each { |y|
        sum += @board[x, y].value if x != i or y != j
      }
    }
    sum == 3 or (sum == 2 and @board[i, j].alive?)
  end
end

class GameBoard
  include Enumerable

  def initialize(size, initial_life=nil)
    @size = size
    @board = Array.new(size) { Array.new(size) { Cell.new false } }
    seed_board initial_life
  end

  def seed_board(life)
    if life.nil?
      # randomly seed board
      each_index.to_a.sample(10).each { |x, y| @board[y][x].live }
    else
      life.each { |x, y| @board[y][x].live }
    end
  end

  def each
    @size.times { |x| @size.times { |y| yield @board[y][x] } }
  end

  def each_index
    return to_enum(__method__) unless block_given?
    @size.times { |x| @size.times { |y| yield x, y } }
  end

  def [](x, y)
    @board[y][x]
  end

  def ==(board)
    self.life == board.life
  end

  def barren?
    none? { |cell| cell.alive? }
  end

  def life
    each_index.select { |x, y| @board[y][x].alive? }
  end

  def display()
    puts "This is your fingerprint\n"
    puts '*'*90
    a = @board.map { |row| row.map { |cell| cell.alive? ? '#' : '.' }.join(' ') }
    puts a
    puts '*'*90
    a
  end

  def apocalypse
    # utility function to entirely clear the game board
    each { |cell| cell.die }
  end
end

class Cell
  def initialize(alive)
    @alive = alive
  end

  def alive?;
    @alive
  end

  def value;
    @alive ? 1 : 0
  end

  def live;
    @alive = true
  end

  def die;
    @alive = false
  end
end

POO_ssl_game_of_life_cypher.new

