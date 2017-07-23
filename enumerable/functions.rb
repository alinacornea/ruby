class Array
    def my_each
    #  takes a block and call the block on every element of the array, returns the original array
        for i in 0...self.size
            yield self[i]
        end
        self
    end
    
    def my_select(&block)
    # takes a block and returns a new array containing only the elements that satisfy the block
        values = []
        self.my_each do |item|
            values << item if block.call(item) 
        end
        values
    end
    
    def my_reject(&block)
        values = []
        self.my_each do |item|
            values << item unless block.call(item)
        end
        values
    end
    
    def my_any?(&block)
        self.my_each {|item| return true if block.call(item) == true}
        false
    end
    
    def my_all?(&block)
        self.my_each {|item| return false if block.call(item) != true}
        true
    end
    
    def my_flatten
        values = []  
        self.my_each do |item|
            (item.is_a?(Array)) ? values.concat(item.my_flatten) : values << item
            end
        values
    end
    
    def my_zip(*args)
        values = []
        i = 0
        while i < self.length
            arr_zip = []
            arr_zip << self[i]
            j = 0
            while j < args.length
                arr_zip << args[j][i]
                j +=1
            end
            i += 1
            values << arr_zip
        end
        values
    end
    
    def my_rotate(shift = 1)
    rot = self.dup
    shift %= self.length
    puts shift
    shift.times do
      rot.push(rot.shift)
    end
    rot
  end

end

# a = [ "a", "b", "c", "d" ]
# print a.my_rotate         #=> ["b", "c", "d", "a"]
# print "\n"
# print a.my_rotate(2)      #=> ["c", "d", "a", "b"]
# print "\n"
# print a.my_rotate(-3)     #=> ["b", "c", "d", "a"]
# print"\n"
# print a.my_rotate(15)     #=> ["d", "a", "b", "c"]
# print"\n"

# a = [ 4, 5, 6 ]
# b = [7, 8, 9 ]
# print [1, 2, 3].my_zip(a, b) # => [[1, 4, 7], [2, 5, 8], [3, 6, 9]]
# a.my_zip([1,2], [8])   # => [[4, 1, 8], [5, 2, nil], [6, nil, nil]]
# [1, 2].my_zip(a, b)    # => [[1, 4, 7], [2, 5, 8]]

# c = [10, 11, 12]
# d = [13, 14, 15]
# [1, 2].my_zip(a, b, c, d)    # => [[1, 4, 7, 10, 13], [2, 5, 8, 11, 14]]

# a = [1, 2, 3]
# puts a.my_any? { |num| num > 1 } # => true
# puts a.my_any? { |num| num == 4 } # => false
# puts a.my_all? { |num| num > 1 } # => false
# puts a.my_all? { |num| num < 4 } # => true

# print [1, 2, 3, [4, [5, 6]], [[[7]], 8, [4, 6]]].my_flatten # => [1, 2, 3, 4, 5, 6, 7, 8]

# a = [1, 2, 3, 6, 7, 8, 4]
# print a.my_reject { |num| num > 1 } # => [2, 3]
# puts "\n"
# puts a.my_reject { |num| num == 4 } # => []

# return_value = [1, 2, 3].my_each do |num|
#   puts num
# end.my_each do |num|
#     puts num
# end
