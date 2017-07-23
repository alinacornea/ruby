require 'set'
require 'colorize'

class Game

  attr_reader :players, :fragment, :dictionary, :losses, :current_player,
              :previous_player

  def initialize(*player)
    @players = player
    @losses = {}
    words = File.readlines("dictionary.txt").map(&:chomp)
    @dictionary = Set.new(words)
    players.each { |player| losses[player] = 0 }
  end

  def current_player
    @current_player = players.first
  end

  def previous_player
    @previous_player = players.last
  end 
  
  def next_player!
    players.rotate!
    current_player
    until losses[current_player] < "ghost".length
      players.rotate!
      current_player
    end
  end

  def add_letter(player)
    letter = player.guess
    until valid_play?(letter)
      player.alert_invalid_guess
      letter = player.guess
    end
    fragment << letter
  end

  def valid_play?(string)
    return false unless string.downcase >= "a" && string.downcase <= "z"
    return false unless string.length == 1
    temp = fragment + string
    dictionary.each do |word|
      return true if word.start_with?(temp)
    end
    false
  end

# playing one round of game till the word is not found in the dictionary
  def play_round
    until dictionary.include?(fragment) && fragment != ""
      puts "Current player : #{current_player.name}"
      add_letter(current_player)
      print "Current fragment of a word: "
      puts "'#{fragment}'".green
      next_player!
    end
    if losses[previous_player] + 1 == "ghost".length
    	puts "#{previous_player.name} it's a ghost and lost this game!".red.bold
    else
    	puts "#{previous_player.name} lost this round!".red.bold
    end
    losses[previous_player] += 1
    @fragment = ""
  end

  def check_status
    @losses.each do |player, lost|
      if lost == "ghost".length
      	(player, _) = @losses.find { |_, loss| loss < "ghost".length}
    	puts "#{player.name} won this game. Congratulations!!".yellow
        players.delete(player)
        @losses.delete(player)
      end 
    end
    update_status
  end

# main method of the game
  def play
  	@fragment = ""
    until @losses.keys.length == 1
      system("clear")
      update_status
      play_round
      check_status
      puts "Next round in 5 seconds...".bold
      sleep(5)
    end
    final_status
  end

  def update_status
  	eliminate = "GHOST"
    @losses.each do |player, loss|
      puts "#{player.name} score: #{loss}".bold
      puts status(player)
    end
  end


  def status(player)
    eliminate = "GHOST"
    eliminate[0...losses[player]]
  end
  
  def final_status
    players.each do |player|
      puts "#{player.name}: #{status(player)}"
    end
  end

end



class Player

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def guess
    print "#{name}, please input a valid letter: ".bold
    gets.chomp
  end

  def alert_invalid_guess
    puts "Invalid guess, enter a letter that will form a word. Try again".red.bold
  end 
end

if __FILE__ == $PROGRAM_NAME
  puts "Welcome to Ghost Game \n   Start the game!".yellow
  puts "Type name of first player:".bold
  name1 = gets.chomp
  puts "Type name of second player:".bold
  name2 = gets.chomp
  player1 = Player.new(name1)
  player2 = Player.new(name2)
  Game.new(player1, player2).play
end
