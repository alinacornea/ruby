require 'set'
require 'colorize'

# given two words of equal length as command-line arguments, built a chain of words 
# connecting the first to the second, where each word only differ by a letter

# my ugly beginning of  code

class WordChainer
    attr_reader :dictionary
    
    def initialize()
        words = File.readlines("dictionary.txt").map(&:chomp)
        @dictionary = Set.new(words)
    end
    
    def check_words?(source, target)
        return true if @dictionary.include?(source) && @dictionary.include?(target) && source.length == target.length
        false
    end

  # select only words that will have the same size and will differ by a letter
  def get_words(current)
    select_words = @dictionary.select { |word| word.length == current.length }
    new_words = []
    select_words.each do |word|
      dif = 0
      (0...current.length).each do |i|
        if word[i] != current[i]
          dif += 1
        end
      end
      if dif == 1
        new_words << word
      end
    end
    # print new_words
    new_words
  end

  def run(source, target)
    @current= [source]
    @all = {source => nil}
    if !check_words?(source, target)
      puts "Please enter 2 valid words with the same length!".bold
      exit 1
    end
    until @current.empty? || @all.include?(target)
      @current = explore
    end
    print_chain(target)
  end

  def explore
    words = []
    @current.each do |curr_word|
      get_words(curr_word).each do |adj_word|
        unless @all.include?(adj_word)
          words << adj_word
          @all[adj_word] = curr_word
        end
      end
    end
    words
  end

  def print_chain(target)
    add_word = target
    path = [target]
    until @all[add_word] == nil
      add_word = @all[add_word]
      path.unshift(add_word)
    end
    p path
  end
end

if __FILE__ == $PROGRAM_NAME
    puts "Word chains:  '#{ARGV[0]}' and '#{ARGV[1]}' \nRunning --->".yellow
    unless ARGV.first
    puts "usage: ./solve.rb word1 word2".bold
    exit 1
end
    name1 = ARGV[0]
    name2 = ARGV[1]
    WordChainer.new().run(name1, name2)
end

