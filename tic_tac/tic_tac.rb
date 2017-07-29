require "colorize"


class Player
  attr_accessor :name, :turn

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @turn = false
  end


  def selection
    sel = gets.chomp.to_i
    exit if sel.to_s == "quit"
    if (1..9).include?(sel) == false
      puts "Please enter a valid cell from 1 to 9 or enter 'quit' to quit the game!".bold
      exit if sel.to_s == "quit"
    end

  end

end



class Game
  attr_accessor :player1, :player2, :board


  def initialize(name1, name2)
    @board = Board.new
    @player1 = Player.new(name1, 'X')
    @player2 = Player.new(name2, 'O')
  end

  def game_over?
    (@board.check_step(@player1, @player2)) ? true : false
  end

  def play
    @board.intructions
    @player1.turn = true
    put_mark
  end

  def put_mark
    until game_over?
      current_player = @player1.turn ? @player1 : @player2
      puts "#{current_player.name}, select a cell to mark! (1-9)".bold
      current_player.selection
      switch_players
    end
  end

  def switch_players
    if player1.turn
      player1.turn = false
      player2.turn = true
    else
      player1.turn = true
      player2.turn = false
    end
  end
end


class Board

  WINS = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8],  # <-- Horizontal wins
    [0, 3, 6], [1, 4, 7], [2, 5, 8],  # <-- Vertical wins
    [0, 4, 8], [2, 4, 6],             # <-- Diagonal wins
  ]

  attr_accessor :matrix, :win

  def initialize
      @matrix = Array.new(3){Array.new(3, " ")}
      @win = ""
  end

  def display
    puts
    puts " #{matrix[0][0]} | #{matrix[0][1]} | #{matrix[1][2]}".cyan
    puts "---|---|---".bold
    puts " #{matrix[1][0]} | #{matrix[1][1]} | #{matrix[1][2]}".cyan
    puts "---|---|---".bold
    puts " #{matrix[2][0]} | #{matrix[2][1]} | #{matrix[2][2]}".cyan
    puts
  end

  def intructions
    @matrix[0][0] = "1"
    @matrix[0][1] = "2"
    @matrix[0][2] = "3"
    @matrix[1][0] = "4"
    @matrix[1][1] = "5"
    @matrix[1][2] = "6"
    @matrix[2][0] = "7"
    @matrix[2][1] = "8"
    @matrix[2][2] = "9"
    puts "To mark a cell just type the number of the cell 1-9: ".bold
    display
  end

  def check_step(*player)
    if WINS.any? { |line| line.all? { |square| @matrix[square] == player } }
      @win = @player
      true
    end
    false
  end


end



if __FILE__ == $PROGRAM_NAME
  puts "Welcome to TIC_TAC_TOE game!".bold.cyan
  puts "Type the name of first player: ".bold.yellow
  name1 = gets.chomp
  puts "Type the name of second player: ".bold.yellow
  name2 = gets.chomp
  Game.new(name1, name2).play
end