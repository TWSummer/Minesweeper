require_relative 'tile'
require 'colorize'

class Board

  def initialize(size, mines)
    @size = size
    @board = Array.new(size) { Array.new(size) }
    scatter_mines(size, mines)
    fill_non_mines
  end

  def reveal(pos)
    tile = @board[pos[0]][pos[1]]
    result = tile.value
    return result if tile.revealed
    tile.reveal
    if result == 0
      reveal_these = adjacent_cells(pos[0], pos[1]).reject do |pos|
        @board[pos[0]][pos[1]].revealed
      end
      reveal_these.each { |pos| reveal(pos) }
    end
    result
  end

  def flag(pos)
    @board[pos[0]][pos[1]].flag
  end

  def display
    print "  #{(1..@size).to_a.join(' ')}\n".colorize(:yellow)
    @board.each_with_index do |row, row_i|
      print "#{row_i + 1} ".colorize(:yellow)
      row.each do |tile|
        print "#{tile.to_s} "
      end
      puts
    end

    def won
      @board.all? do |row|
        row.all? do |tile|
          tile.revealed || tile.value == "*"
        end
      end
    end
  end

  private

  def scatter_mines(size, mines)
    available_squares = size**2
    remaining_mines = mines
    @board.each_with_index do |row, row_i|
      row.each_index do |col_i|
        if rand < remaining_mines.to_f / available_squares
          @board[row_i][col_i] = Tile.new("*")
          remaining_mines -= 1
        end
        available_squares -= 1
      end
    end
  end

  def fill_non_mines
    @board.each_with_index do |row, row_i|
      row.each_index do |col_i|
        @board[row_i][col_i] ||= Tile.new(count_adjacent_bombs(row_i, col_i))
      end
    end
  end

  def count_adjacent_bombs(row, col)
    adjacent_cells(row, col).count do |pos|
      pos_val = @board[pos[0]][pos[1]]
      pos_val.is_a?(Tile) && pos_val.value == "*"
    end
  end

  def adjacent_cells(row, col)
    result = []
    result << [row - 1, col - 1] if row > 0 && col > 0
    result << [row, col - 1] if col > 0
    result << [row + 1, col - 1] if row < @size - 1 && col > 0
    result << [row - 1, col] if row > 0
    result << [row + 1, col] if row < @size - 1
    result << [row - 1, col + 1] if row > 0 && col < @size - 1
    result << [row, col + 1] if col < @size - 1
    result << [row + 1, col + 1] if row < @size - 1 && col < @size - 1
    result
  end

end
