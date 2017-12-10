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
      get_input
      @game_over = true
    end
  end

private

  def get_input
    puts "Enter a cell to reveal in row,column format. ex: \"3,4\""
    result = gets.chomp
    until valid_input(result)
      puts "I'm sorry. That input is not valid. Please try again."
      result = gets.chomp
    end
    result
  end

  def valid_input(str)
    pos = str.split(",")
    return false unless pos.length == 2
    pos.map!(&:to_i)
    return false unless pos.all? { |num| num > 0 && num <= @size }
    true
  end
end

if $PROGRAM_NAME == __FILE__
  Game.new().play
end
