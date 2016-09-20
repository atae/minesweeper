require_relative 'board'
require "byebug"
class MineSweeper

  def initialize(grid)
    @grid = grid
    @system_message = " "
  end


  def play
    puts "Welcome to A.W. Minesweeper!"
    puts "Let's get started. "
    retry_state = true
    until retry_state == false
      until game_over?
      pos = get_coordinate
      get_options(pos)
      neighbors = @grid.neighbors(pos)

      #debugger
      @grid.render(@system_message)
      end
      puts @system_message
      retry_state = retry?
      #byebug
      if retry_state == true
        board = Board.shuffle
        board.render
        minesweeper = MineSweeper.new(board)
        minesweeper.play
      end

    end

    puts 'Bye!'
  end

  def game_over?
    return true if won? || lost?
  end

  def retry?
    user_input = ''
    until user_input =~ /y/ || user_input =~ /n/
      puts "Retry? Y/N"
      user_input = gets.chomp.downcase
    end

    return false if user_input =~ /n/
    return true if user_input =~ /y/
  end

  def get_coordinate
    pos = []
    until acceptable_coordinate?(pos)
      puts "Give us a coordinate!"
      pos = gets.chomp
      pos = pos.split(',').map(&:to_i)
      puts "that's out of the range!" if !acceptable_coordinate?(pos)
      unless pos.length != 2
        puts "that's already revealed. try again!" if @grid[pos].revealed
      end
    end
    pos
  end

  def acceptable_coordinate?(pos)
    return false if pos == []
    return false if pos.length != 2
    return false if @grid[pos].revealed
    return pos[0] < 9 && pos[1] < 9 && pos[0] >=0 && pos[1] >=0
  end

  def get_options(pos)
    puts "Do you want to flag or reveal? (F/R)"
    option = ''
    until option =~ /[f]/ || option =~ /[r]/

      option = gets.chomp.downcase
      unless option.split('').include?("f") || option.split('').include?("r")
        puts "Please select flag or reveal !! (F/R)"
      end
      @grid[pos].flagify if option =~ /[f]/
      if option =~ /[r]/
        if @grid[pos].bomb == true
          @grid[pos].reveal
          @system_message = "Ouch, that's a mine! You lose babe!".colorize(:color => :black)
        else
          @grid[pos].bomb_counter = @grid.reveal_neighbors(pos)
        end

      end
    end
  end

  def won?
    @grid.grid.each do |row|
      row.each do |pos|
        if (pos.revealed == false || !pos.flag)
          return false
        elsif (pos.bomb == true && pos.flag == false)
          return false
        end
      end
    end

    @system_message =  "You found all of the mines! Congrats babe!".colorize(:color=> :green)
    true

  end

  def lost?
    @grid.grid.each do |row|
      row.any? do |tile|
        return true if tile.revealed && tile.bomb
      end
    end
    return false
  end
end


if __FILE__ == $PROGRAM_NAME
  board = Board.shuffle
  board.render
  minesweeper = MineSweeper.new(board)
  minesweeper.play
end
