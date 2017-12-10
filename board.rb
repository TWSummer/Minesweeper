require_relative 'tile'

class Board

  def initialize(size, mines)
    @board = Array.new(size) { Array.new(size) }
    scatter_mines(size, mines)
  end

  def scatter_mines(size, mines)
    available_squares = size ** 2
    remaining_mines = mines
    @board.each_with_index do |row, row_i|
      row.each_index do |col_i|
        if rand() < remaining_mines.to_f / available_squares
          @board[row_i][col_i] = Tile.new("*")
          remaining_mines -= 1
        end
        available_squares -= 1
      end
    end
  end

end
