class Board
  
  # @grid:
  # +---+---+---+
  # | 0 | 1 | 2 |
  # +---+---+---+
  # | 3 | 4 | 5 |
  # +---+---+---+
  # | 6 | 7 | 8 |
  # +---+---+---+
  
  attr_reader :grid
  
  def initialize
    # -1 for unset squares
    @grid = Array.new(9, -1)
  end
  
  # returns false if illegal move
  # and player id if it is legal
  def move(square, player)
    # check if square is taken
    if not @grid[square] == -1 
      return false      
    end
    @grid[square] = player
  end
  
  # resets the grid
  def reset 
    @grid.replace(Array.new(9, -1))
  end
  
  # returns the id of the winner
  # -1 for stalemate or false if
  # game is not over
  def game_over?
    for i in 0..2
      if @grid[3*i] != -1 && @grid[3*i] == @grid[3*i + 1] && @grid[3*i + 1] == @grid[3*i + 2]
        return @grid[3*i]
      elsif @grid[i] != -1 && @grid[i] == @grid[i + 3] && @grid[i + 3] == @grid[i + 6]
        return @grid[i]
      end
    end
    
    if @grid[0] != -1 && @grid[0] == @grid[4] && @grid[4] == @grid[8]
      return @grid[0]
    elsif @grid[2] != -1 && @grid[2] == @grid[4] && @grid[4] == @grid[6]
      return @grid[2]
    end
    
    if not @grid.include?(-1)
      return -1
    end
    
    false
  end

end