require "colorize"
require 'matrix'


class Player
  attr_accessor :name, :turn, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
    @turn = false
  end

  def selection
    sel = gets.chomp
    exit if sel.to_s == "quit"
    if (1..9).include?(sel.to_i) == false
      puts "Please enter a valid cell from 1 to 9 or enter 'quit' to quit the game!".bold
      sel = gets.chomp
      exit if sel.to_s == "quit"
    end
    $board.parse_selection(sel.to_i, symbol)
  end

end



class Game
  attr_accessor :player1, :player2, :board


  def initialize(name1, name2)
    $board = Board.new
    @player1 = Player.new(name1, 'X'.red)
    @player2 = Player.new(name2, 'O'.green)
  end

  def play
    $board.intructions
    player1.turn = true
    put_mark
  end

  def put_mark
    until $board.check_step?(player1.name, player2.name)
      current_player = player1.turn ? player1 : player2
      puts "#{current_player.name}, mark!".bold
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

  WINS =
  [[0, 1, 2],
   [3, 4, 5],
   [6, 7, 8],
   [0, 4, 8],
   [2, 4, 6],
   [0, 3, 6],
   [1, 4, 7],
   [2, 5, 8]]

  attr_accessor :matrix, :win

  def initialize
      @matrix = Array.new(3) {Array.new(3) }
      @win = false
  end

  def display
    puts
    puts " #{matrix[0][0]} | #{matrix[0][1]} | #{matrix[0][2]}".bold
    puts "---|---|---".bold
    puts " #{matrix[1][0]} | #{matrix[1][1]} | #{matrix[1][2]}".bold
    puts "---|---|---".bold
    puts " #{matrix[2][0]} | #{matrix[2][1]} | #{matrix[2][2]}".bold
    puts
  end

  def intructions
    matrix[0][0] = 1
    matrix[0][1] = 2
    matrix[0][2] = 3
    matrix[1][0] = 4
    matrix[1][1] = 5
    matrix[1][2] = 6
    matrix[2][0] = 7
    matrix[2][1] = 8
    matrix[2][2] = 9
    puts "To mark a cell just type the number of the cell 1-9: ".bold
    display
  end


  def parse_selection(sel, symbol)
      row = matrix.detect{|a| a.include?(sel)}
      x = matrix.index(row)
      if x.is_a? Integer
        y = row.index(sel)
        matrix[x][y] = symbol
      else
        puts "This place is taken.".bold
      end
    display
  end

  def check_step?(player1, player2)
  combo = 0
  arr = matrix.flatten
  while combo < WINS.length
    current_combo = WINS[combo]

    p1 = current_combo.all? { |position| arr[position] == "\e[0;31;49mX\e[0m" }
    p2 = current_combo.all? { |position| arr[position] == "\e[0;32;49mO\e[0m" }
    if p1 == true || p2  == true
      p1 ? (puts "#{player1}, is the winner!".yellow.bold) : (puts "#{player2}, is the winner!").yellow.bold
      return current_combo
    end
    combo += 1
  end
  false
  end

end



if __FILE__ == $PROGRAM_NAME
  puts "Welcome to TIC_TAC_TOE game!\n".bold.cyan
  puts "Type the name of first player: ".bold.yellow
  name1 = gets.chomp
  puts "Type the name of second player: ".bold.yellow
  name2 = gets.chomp
  Game.new(name1, name2).play
end
