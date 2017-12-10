require_relative 'board.rb'

class Game

  def initialize(size = 9, mines = 20)
    @board = Board.new(size, mines)
    @size = size
    @mines = mines
    @remaining_tiles = size**2 - mines
    @game_over = false
  end

  def play
    until @game_over
      @board.display
      input = get_input
      revealed = @board.reveal(input)
      @remaining_tiles -= 1
      check_end_conditions(revealed)
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
    parse_input(result)
  end

  def valid_input(str)
    pos = str.split(",")
    return false unless pos.length == 2
    pos.map!(&:to_i)
    return false unless pos.all? { |num| num > 0 && num <= @size }
    true
  end

  def parse_input(str)
    str.split(",").map { |num| num.to_i - 1 }
  end

  def check_end_conditions(value)
    @game_over = true if value == "*"
    lose if @game_over
    win if @remaining_tiles == 0 && !@game_over
  end

  def win
    @board.display
    puts "Congratulations, you win!"
    @game_over = true
  end

  def lose
    @board.display
    puts "Oh no! You set off a bomb. You are now dead."
  end
end

if $PROGRAM_NAME == __FILE__
  Game.new().play
end
