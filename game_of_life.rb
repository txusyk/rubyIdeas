class Game_of_life
  def initialize(data)
    @living_neighbor_counts = Hash.new(0)
    if data.is_a? String
      map = data
      mark_living_cells_in_map(map)
    else
      @living_cells = {}
      living_cells = data
      living_cells.each do |coordinate, _|
        mark_living(*coordinate)
      end
    end
  end

  def to_s
    result = ""
    20.times do |y|
      20.times do |x|
        print_char = @living_cells[[x, y]] ? '*' : ' '
        result << print_char
      end
      result << "\n"
    end
    result
  end

  def iterate
    spawned = @living_neighbor_counts.select { |coordinate, count| count == 3 }
    survived = @living_cells.select { |coordinate, _| @living_neighbor_counts[coordinate] == 2 }
    grid = Game_of_life.new(spawned.merge survived)
  end

  private

  def mark_living_cells_in_map(map)
    @living_cells = {}
    map.lines.each_with_index do |line, y|
      line.chomp.chars.each_with_index do |char, x|
        next if char == ' '
        mark_living(x, y)
      end
    end
  end

  def mark_living(x, y)
    @living_cells[[x, y]] = true
    neighbors_of(x, y).each do |(x, y)|
      @living_neighbor_counts[[x, y]] += 1
    end
  end

  def neighbors_of(x, y)
    [
        [x-1, y-1],
        [x, y-1],
        [x+1, y-1],
        [x-1, y],
        [x+1, y],
        [x-1, y+1],
        [x, y+1],
        [x+1, y+1],
    ]
  end
end

grid = Game_of_life.new <<-MAP


=begin
    ---   ---

  -    - -    -
  -    - -    -
  -    - -    -
    ---   ---

    ---   ---
  -    - -    -
  -    - -    -
  -    - -    -

    ---   ---
=end

  *---   *---

.....**.........
....*..*...
....*.*....
..**.*...*.
.*..*...*.*
.*.*...*..*
..*...*.**.
.....*.*...
....*..*...
.....**....



MAP
loop do
  puts "\e[H\e[2J"
  puts grid.to_s
  grid = grid.iterate
  sleep 0.5
end