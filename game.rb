require_relative 'board.rb'

class Game

  def initialize(size = 9, mines = 5)
    @board = Board.new(size, mines)
    @size = size
    @mines = mines
    @mines_remaining = mines
    @game_over = false
  end

  def play
    until @game_over
      @board.display
      act_on_input(get_input)
    end
  end

private

  def get_input
    puts "There are #{@mines_remaining} mines remaining."
    puts "Enter a move ex: \"r34\" to reveal row 3, colum 4. \"f34\" to flag that cell"
    result = gets.chomp
    until valid_input(result)
      puts "I'm sorry. That input is not valid. Please try again."
      result = gets.chomp
    end
    parse_input(result)
  end

  def valid_input(str)
    return false unless str.length == 3
    return false unless str[0] == "r" || str[0] == "f"
    pos = str[1..-1].split("")
    return false unless pos.length == 2
    pos.map!(&:to_i)
    return false unless pos.all? { |num| num > 0 && num <= @size }
    true
  end

  def parse_input(str)
    [str[0]].concat(str[1..-1].split("").map { |num| num.to_i - 1 })
  end

  def act_on_input(input)
    command = input[0]
    if command == "r"
      revealed = @board.reveal(input.drop(1))
      check_end_conditions(revealed)
    elsif command == "f"
      @mines_remaining += @board.flag(input.drop(1))
    end
  end

  def check_end_conditions(value)
    @game_over = true if value == "*"
    lose if @game_over
    win if @board.won && !@game_over
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
