require 'colorize'

class Sudoku

  def initialize(matrix=nil)
    @matrix = matrix
  end

  # element reference and assignment 
  def []=(x, y, mark)
    @matrix[y][x] = mark
  end

  # serialize objects into binary data
  def clone
    Sudoku.new Marshal.load(Marshal.dump(@matrix))
  end

  # get data from the file
  def import_problem(file_name)
    @matrix = File.open(file_name).readlines.map do |row|
      row.chomp.split('').map { |cell| cell.to_i }
    end
  end

  # printing the initial and final board
  def display	
  	string = "\n +-----------------------+".green
  	@matrix.each_index{ |i|
  	string += "\n |".green
    v = @matrix[i]
    	v.each_index{|j|
    		if (v[j] != 0)
    			string += " " + v[j].to_s
    		else 
    			string += " ."
    		end
    				
    		if (j == 2 || j == 5 || j == 8)
    			string += " |".green
    		end
    		}
    		if (i == 2 || i == 5)
    			string += "\n |-------+-------+-------|".green
    		end
  	}
  	string += "\n +-----------------------+".green
	end
	
	def print_board
    puts display
  end
  
  
  # solvable method of sudoku using backtraking
  def solve!
    x, y = current = next_val
    return self unless current
    successors(x, y).each do |i|
      successor = clone
      successor[x, y] = i
      solution = successor.solve!
      return solution if solution
    end
    false
  end

  private

  def next_val
    @matrix.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        return [x, y] if cell == 0
      end
    end
    nil
  end

  def successors(x, y)
    possible_values - column_values(x) - row_values(y) - group_values(x, y)
  end

  def possible_values
    (1..matrix_size).to_a
  end

  def column_values(x)
    @matrix.map { |row| row[x] }
  end

  def row_values(y)
    @matrix[y]
  end

  def matrix_size
	  @matrix.size
  end

  def group_size
    @group_size ||= Math.sqrt(@matrix.size).floor
  end

  def group_range(n)
    low  = n / group_size * group_size
    high = low + group_size - 1
    low..high
  end
  
  def group_values(x, y)
    @matrix[group_range(y)].map { |row| row[group_range(x)] }.flatten
  end
  
end



# beginning of problem
unless ARGV.first
  puts "usage: ./solve.rb file_to_solve".yellow
  exit 1
end

sudoku = Sudoku.new
sudoku.import_problem ARGV.first
sudoku.print_board

puts "\n"
puts "Solving...".bold.yellow
puts "\n"

if solution = sudoku.solve!
  solution.print_board
else
  puts "No true solutions was found, input another case!".red.bold
end

