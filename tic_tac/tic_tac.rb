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
    @player1 = Player.new(name1, 'X')
    @player2 = Player.new(name2, 'O')
  end

  def game_over?
    $board.check_step ? true : false
  end

  def play
    $board.intructions
    @player1.turn = true
    put_mark
  end

  def put_mark
    until game_over?
      current_player = @player1.turn ? @player1 : @player2
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

  WINS = [[0, 1, 2], [3, 4, 5], [6, 7, 8], #Horizontal
     [0, 3, 6], [1, 4, 7], [2, 5, 8], #Vertical
     [0, 4, 8], [2, 4, 6]]            #Diagonal

  attr_accessor :matrix, :win

  def initialize
      @matrix = Array.new(3) {Array.new(3) }
      @winner_board = Array.new(3) {Array.new(8)}
      @win = false
  end

  def display()
    puts
    puts " #{matrix[0][0]} | #{matrix[0][1]} | #{matrix[0][2]}".bold
    puts "---|---|---".bold
    puts " #{matrix[1][0]} | #{matrix[1][1]} | #{matrix[1][2]}".bold
    puts "---|---|---".bold
    puts " #{matrix[2][0]} | #{matrix[2][1]} | #{matrix[2][2]}".bold
    puts
  end

  def intructions
    @matrix[0][0] = 1
    @matrix[0][1] = 2
    @matrix[0][2] = 3
    @matrix[1][0] = 4
    @matrix[1][1] = 5
    @matrix[1][2] = 6
    @matrix[2][0] = 7
    @matrix[2][1] = 8
    @matrix[2][2] = 9
    puts "To mark a cell just type the number of the cell 1-9: ".bold
    display
  end


  def parse_selection(sel, symbol)
      row = @matrix.detect{|a| a.include?(sel)}
      x = @matrix.index(row)
      y = row.index(sel)
      @matrix[x][y] = symbol

    display
  end

  def check_step
    WINS.each do |win|
      print @matrix
      if check_combination?('X', win)
        return win
      elsif check_combination?('O', win)
        return win
      else
        return false
      end
    end
  end

  def check_combination?(player, win)
    win.all? do |position|
      @matrix[position] == player
    end
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
