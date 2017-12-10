class Game

  def initialize(size = 9, mines = 20)
    @board = Board.new()
    @size = size
    @mines = mines
  end
end

if $PROGRAM_NAME == __FILE__

end
