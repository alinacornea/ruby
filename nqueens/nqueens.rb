require 'colorize'

class Board
  SIZE = 8
  @@h = '-'.bold.blue
  @@v = '|'.bold.blue
  @@b = '-'.bold.blue

  attr_accessor :queens

  def initialize(options={})
    @size = options[:size] || SIZE
    @queens = []
  end

  def rows
    @size
  end

  def starting_row
    0
  end

  def ending_row
    rows - 1
  end

  def columns
    @size
  end

  def starting_col
    0
  end

  def ending_col
    columns - 1
  end

  def safe_column?(column)
    queens.none? {|q| q.column == column}
  end

  def safe_row?(row)
    queens.none? {|q| q.row == row}
  end

  def safe_diagonal?(column, row)
    queens.none? do |q|
      (q.column - column).abs == (q.row - row).abs
    end
  end

  def place_queen(column=0, row=0)
    queen = Queen.new
    @queens << queen
    queen.column = column
    queen.row = row
    return queen
  end

  def delete_queen(column, row)
    queen = find_queen(column, row)
    if queen
      queen.column = nil
      queen.row = nil
      @queens.delete(queen)
    end
  end

  def display
    puts
    puts @@h * (columns + 2)
    rows.times do |row|
      print @@v
      columns.times do |column|
        print contents_at(column, row)
      end
      puts @@v
    end
    puts @@h * (columns + 2)
    puts
  end

  def safe_position?(column, row)
    return false unless safe_row?(row)
    return false unless safe_column?(column)
    return false unless safe_diagonal?(column, row)
    return true
  end

  private

  def find_queen(column, row)
    @queens.detect {|q| q.location?(column, row)}
  end

  def contents_at(column, row)
    find_queen(column, row) || @@b
  end
end

class Queen
  @@string = 'Q'

    attr_accessor :column, :row

    def to_s
      @@string.bold.yellow
    end

    def location
      [column, row]
    end

    def location?(x, y)
      location == [x, y]
    end
end

def add_solution(board)
    sol = Board.new
    sol.queens = board.queens.map(&:dup)
    @all_solutions << sol
end

def solve_problem(column)
    @board.rows.times do |row|
        if @board.safe_position?(column, row)
            @board.place_queen(column, row)
            if column == @board.ending_col
                add_solution(@board)
            else
                solve_problem(column + 1)
            end
            @board.delete_queen(column, row)
        end
    end    
end

@solution = false
@all_solutions = []
@board = Board.new
solve_problem(0)
if !@all_solutions.empty?
    @all_solutions.each_with_index do |sol, i|
      puts "\n Solution board: #{i} "
      sol.display
    end
else
  puts "No solution were found."
end

