# --- Day 3: Perfectly Spherical Houses in a Vacuum ---
# 
# Santa is delivering presents to an infinite two-dimensional grid of houses.
# 
# He begins by delivering a present to the house at his starting location, and then an elf at the North Pole calls him via radio and tells him where to move next. Moves are always exactly one house to the north (^), south (v), east (>), or west (<). After each move, he delivers another present to the house at his new location.
# 
# However, the elf back at the north pole has had a little too much eggnog, and so his directions are a little off, and Santa ends up visiting some houses more than once. How many houses receive at least one present?
# 
# For example:
# 
# > delivers presents to 2 houses: one at the starting location, and one to the east.
# ^>v< delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
# ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.
#
# --- Part Two ---

# The next year, to speed up the process, Santa creates a robot version of himself, Robo-Santa, to deliver presents with him.
# 
# Santa and Robo-Santa start at the same location (delivering two presents to the same starting house), then take turns moving based on instructions from the elf, who is eggnoggedly reading from the same script as the previous year.
# 
# This year, how many houses receive at least one present?
# 
# For example:
# 
# ^v delivers presents to 3 houses, because Santa goes north, and then Robo-Santa goes south.
# ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back where they started.
# ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction and Robo-Santa going the other.

class Santa
  attr_accessor :x, :y, :visited, :houses

  def initialize
    @x = 0
    @y = 0
    @visited  = Hash.new { |k, v| k[v] = {} }
    @visited[x][y] = true
    @houses = 1
  end

  def move(direction)
    case direction
    when '^'
      self.y += 1
    when '>'
      self.x += 1
    when 'v'
      self.y -= 1
    when '<'
      self.x -= 1
    end

    if visited[x][y].nil?
      visited[x][y] = true
      self.houses += 1
    end
  end
end

class SantaAndRobotSanta
  attr_accessor :visited, :houses

  def initialize
    @x1 = 0
    @y1 = 0
    @x2 = 0
    @y2 = 0
    @robot = false
    @visited  = Hash.new { |k, v| k[v] = {} }
    @visited[x][y] = true
    @houses = 1
  end

  def move(direction)
    case direction
    when '^'
      self.y += 1
    when '>'
      self.x += 1
    when 'v'
      self.y -= 1
    when '<'
      self.x -= 1
    end

    if visited[x][y].nil?
      visited[x][y] = true
      self.houses += 1
    end

    toggle
  end

  def x=(x)
    robot? ? @x2 = x : @x1 = x
  end

  def x
    robot? ? @x2 : @x1
  end

  def y=(y)
    robot? ? @y2 = y : @y1 = y
  end

  def y
    robot? ? @y2 : @y1
  end

  def robot?
    @robot
  end

  def toggle
    @robot = !@robot
  end
end

f = File.new('day_03.input')
s = Santa.new
rs = SantaAndRobotSanta.new

f.each_char do |d|
  s.move(d)
  rs.move(d)
end

puts "Houses visited by Santa: #{s.houses}."
puts "Houses visited by Santa and Robot Santa: #{rs.houses}."
