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
        return true if dictionary.include?(source) && dictionary.include?(target)
        false
    end
    
    def first_letter(str, letter, len)
        str  = dictionary.select { |word| word.start_with?(letter) && word.size == len }
        # puts "No words were found with this word".red
    end
    
    def run(source, target)
        check_words?(source, target)
        # arr1 = []
        # arr2 = []
        puts arr1 = first_letter(arr1, source[0], source.size)
        puts arr2 = first_letter(arr2, target[0], target.size)
    end

end


if __FILE__ == $PROGRAM_NAME
    puts "Word chains: ".yellow
    name1 = ARGV[0]
    name2 = ARGV[1]
    WordChainer.new().run(name1, name2)
end

