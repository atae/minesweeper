require_relative "tile"
require "colorize"
require 'byebug'
class Board
  attr_accessor :grid
  DIRECTIONS = [[-1, 0], [-1, 1], [-1, -1], [0, 1], [0, -1], [1, -1], [1, 0], [1, 1]]

  def initialize(tiles)
    @grid = tiles
  end


  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def self.shuffle
    blank_tiles = []
    counter = 0

    1.upto(72) do
      blank_tiles << false
    end

    1.upto(9) do
      blank_tiles << true
    end

    blank_tiles.shuffle!

    tiles = Array.new(9) {[]}
    index = 0

    blank_tiles.each do |tile|
      tiles[index] << tile
      counter += 1
      index += 1 if counter % 9 == 0
    end

    tiles = tiles.map do |row|
      row.map do |tile|
        Tile.new(tile)
      end
    end

    self.new(tiles)


  end

  def neighbors(pos)
    neighbors = []
    x , y = pos
    DIRECTIONS.each do |direction|
      i,j = direction
      next if i+x >=9 || x+i <0 || y +j >=9 || y+j <0
      neighbors << [x+i,y+j] unless @grid[x+i][y+j].revealed
    end
    neighbors
  end

  def bomb_counter(array_of_neighbors)
    bomb_counter = 0
    array_of_neighbors.each do |neighbor|
      bomb_counter +=1 if @grid[neighbor[0]][neighbor[1]].bomb
    end
    return bomb_counter
  end

  def reveal_neighbors(pos)
      neighbors = neighbors(pos)
      bomb_count = bomb_counter(neighbors)
      @grid[pos[0]][pos[1]].reveal
      @grid[pos[0]][pos[1]].bomb_counter = bomb_count


      return bomb_count if bomb_count > 0
      neighbors.each do |pos|
        reveal_neighbors(pos) if @grid[pos[0]][pos[1]].bomb_counter == 0
      end
      return bomb_count
  end

  def render(system_message = nil)
    system('clear')
    puts "   "+(0..8).to_a.map{|num| num.to_s.colorize(:color => :red)}.join("   ")
    @grid.each_with_index do |row, idx|

      row = row.map do |tile|
       if tile.revealed && !tile.bomb
         if tile.bomb_counter == 0
           "   "
         else
           " #{tile.bomb_counter} "
         end
      elsif tile.flag
         " f ".colorize(:color => :light_blue, :background => :red)
      elsif tile.bomb && tile.revealed
        " * ".colorize(:color => :red, :background => :black)
      elsif tile.bomb #TODO:replace this with if lost?
         " X ".colorize(:color => :black, :background => :white)
       else
         " * ".colorize(:color => :white, :background => :light_black)
       end
     end.join('|')
    puts "#{idx}".colorize(:color => :red)+" " + row
    puts "--------------------------------------"

    end
  end
end
