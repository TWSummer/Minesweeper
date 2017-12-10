require_relative 'board.rb'

class Game

  def initialize(size = 9, mines = 20)
    @board = Board.new(size, mines)
    @size = size
    @mines = mines
  end
end

if $PROGRAM_NAME == __FILE__
  p Game.new()
end
