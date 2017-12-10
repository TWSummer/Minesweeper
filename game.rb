require_relative 'board.rb'

class Game

  def initialize(size = 9, mines = 20)
    @board = Board.new(size, mines)
    @size = size
    @mines = mines
    @game_over = false
  end

  def play
    until @game_over
      @board.display
      # get_input
      @game_over = true

    end
  end

end

if $PROGRAM_NAME == __FILE__
  Game.new().play
end
