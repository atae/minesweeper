class Tile
  attr_accessor :bomb, :revealed, :flag, :bomb_counter

  def initialize(bomb)
    @bomb = bomb
    @revealed = false
    @flag = false
    @bomb_counter = 0
  end

  def flagify
    if @flag
      @flag = false
    else
      @flag =true
    end
  end

  def reveal
    @revealed = true
  end


end
