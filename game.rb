require_relative 'board.rb'
require 'yaml'
require 'colorize'

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
      system("clear")
      @board.display
      act_on_input(get_input)
    end
  end

  def self.start_game
    puts "Welcome to Minesweeper"
    puts "Type \"load save_name\" to load a game or hit enter to start a new game."
    response = gets.chomp
    return Game.new if response.length <= 5
    return Game.load(response[5..-1].downcase) if response[0..4].downcase == "load "
    Game.new
  end

  def self.load(name)
    YAML::load(File.read("#{name}.yml"))
  end

  private

  def get_input
    puts "There are #{@mines_remaining} mines remaining."
    list_commands
    puts "Enter move:"
    result = gets.chomp
    until valid_input(result)
      puts "I'm sorry. That input is not valid. Please try again."
      result = gets.chomp
    end
    parse_input(result)
  end

  def list_commands
    puts "r\#\# to reveal a cell. ex: r34 will reveal row 3, column 4".colorize(:red)
    puts "f\#\# to flag or unflag a cell. ex: f34 will flag row 3, column 4".colorize(:red)
    puts "s file_name to save your game with the name \"file_name\"".colorize(:red)
  end

  def valid_input(str)
    return true if str.length > 2 && str[0] == "s" && str[1] == " "
    return false unless str.length == 3
    return false unless str[0] == "r" || str[0] == "f"
    pos = str[1..-1].split("")
    return false unless pos.length == 2
    pos.map!(&:to_i)
    return false unless pos.all? { |num| num > 0 && num <= @size }
    true
  end

  def parse_input(str)
    if str[0] == "r" || str[0] == "f"
      [str[0]].concat(str[1..-1].split("").map { |num| num.to_i - 1 })
    else
      [str[0],str[2..-1]]
    end
  end

  def act_on_input(input)
    command = input[0]
    if command == "r"
      revealed = @board.reveal(input.drop(1))
      check_end_conditions(revealed)
    elsif command == "f"
      @mines_remaining += @board.flag(input.drop(1))
    elsif command == "s"
      save(input[1])
    end
  end

  def check_end_conditions(value)
    @game_over = true if value == "*"
    lose if @game_over
    win if @board.won && !@game_over
  end

  def win
    system("clear")
    @board.display
    puts "Congratulations, you win!"
    @game_over = true
  end

  def lose
    system("clear")
    @board.display
    puts "Oh no! You set off a bomb. You are now dead."
  end

  def save(name)
    File.open("#{name.downcase}.yml", "w") do |f|
      f.print self.to_yaml
    end
  end



end

if $PROGRAM_NAME == __FILE__
  Game.start_game.play
end
