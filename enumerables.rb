### ### ### ### ### ### ### ### ### ### ###
#        Ruby         #         By        #
#      Project 2      #     @wandji20     #
#     Enumerables     #     @od-c0d3r     #
###  ###  ####  ### ### ### ### ### ### ###

# rubocop:disable Metrics/ModuleLength,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity,Metrics/MethodLength
module Enumerable
  # my_each()
  def my_each()
    return to_enum(:my_each) unless block_given?

    each do |item|
      yield item if block_given?
    end
  end

  # my_each_with_index()
  def my_each_with_index()
    return to_enum(:my_each_with_index) unless block_given?

    index = 0
    my_each do |item|
      yield(item, index) if block_given?
      index += 1
    end
  end

  # my_select
  def my_select()
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |item| new_arr << item if yield(item) }
    new_arr
  end

  # my_all?
  def my_all?(arg = nil, &_block)
    flag = true
    case arg
    when Class
      my_each { |item| flag = false unless item.is_a? arg }
    when Regexp
      my_each { |item| flag = false if arg.match(item.to_s).nil? }
    when String
      my_each { |item| flag = false unless item.include? arg }
    when Integer
      my_each { |item| flag = false unless item == arg }
    when nil
      unless block_given?
        arg = proc { |obj| obj }
        my_each { |item| flag = false if (arg.call(item) == false) || arg.call(item).nil? }
        return flag
      end
      my_each { |item| flag = false if (yield(item) == false) || yield(item).nil? }
      return flag
    end
    flag
  end

  # my_any?
  def my_any?(arg = nil)
    flag = false
    case arg
    when Class
      my_each { |item| flag = true if item.is_a? arg }
    when Regexp
      my_each { |item| flag = true if arg.match(item.to_s) }
    when String
      my_each { |item| flag = true if item.to_s.include? arg }
    when Integer
      my_each { |item| flag = true if item == arg }
    end
    if block_given? && arg.nil?
      my_each { |item| flag = true if yield(item) }
    elsif !block_given? && arg.nil?
      arg = proc { |obj| obj }
      my_each { |item| flag = true unless [nil, false].include?(item) }
    end
    flag
  end

  # my_none?
  def my_none?(arg = nil)
    flag = true
    case arg
    when Class
      my_each { |item| flag = false if item.is_a? arg }
    when Regexp
      my_each { |item| flag = false if arg.match(item) }
    when String
      my_each { |item| flag = false if item.to_s.include? arg }
    when Integer
      my_each { |item| flag = false if item == arg }
    end
    if block_given? && arg.nil?
      my_each { |item| flag = false if yield(item) }
    elsif !block_given? && arg.nil?
      arg = proc { |obj| obj }
      my_each { |item| flag = false if arg.call(item) }
    end
    flag
  end

  # my_count
  def my_count(arg = nil)
    counter = 0
    if arg
      my_each { |item| counter += 1 if item == arg }
    elsif block_given?
      my_each { |item| counter += 1 if yield(item) }
    else
      my_each { counter += 1 }
    end
    counter
  end

  # my_map
  def my_map(proc = nil, &block)
    return to_enum(:my_map) unless block_given?

    new_arr = []
    if proc.is_a? Proc
      my_each do |item|
        new_item = proc.call(item)
        new_arr << new_item
      end
      return new_arr
    end

    my_each do |item|
      new_item = block.call(item)
      new_arr << new_item
    end
    new_arr
  end

  # my_inject
  def my_inject(init = nil, sign = nil)
    raise LocalJumpError unless block_given? || sign || init || my_all?(String)

    if init && sign
      result = init
      my_each { |item| result = result.send(sign, item) }
    elsif init.is_a?(Symbol) || init.is_a?(String)
      result = first
      range_arr = to_a
      (1..size - 1).my_each { |item| result = result.send(init.to_sym, range_arr[item]) }
    elsif my_all?(String)
      longest_word = ''
      my_each { |item| longest_word = item if item.size > longest_word.size }
      return longest_word
    elsif block_given?
      if init
        result = init
        my_each { |item| result = yield(result, item) }
      else
        result = first
        range_arr = to_a
        (1..size - 1).my_each { |item| result = yield(result, range_arr[item]) }
      end
    end
    result
  end

  # end Module
end

# multiply_els to test #my_inject
def multiply_els(array)
  array.my_inject(:*)
end

# rubocop:enable Metrics/ModuleLength,Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity,Metrics/MethodLength

### ### ### ### ###
#                 #
#   Code Testing  #
#                 #
###  ###  ####  ###

#############################################

# puts '1.--------my_each--------'
#  %w[Sharon Leo Leila Brian Arun].my_each { |friend| puts friend }
#  p "--------------"
#  %w[Sharon Leo Leila Brian Arun].each { |friend| puts friend }

# puts '2.--------my_each_with_index--------'
# %w[Sharon Leo Leila Brian Arun].my_each_with_index { |friend, index| puts friend if index.even? }
# [1,2,3].my_each_with_index{ |ele, index| puts ele if index.even? }

# puts '3.--------my_select--------'
#puts (%w[Sharon Leo Leila Brian Arun].my_select { |friend| friend != 'Brian' })

# puts '4.--------my_all--------'
 puts (%w[ant bear cat].my_all? { |word| word.length >= 3 }) #=> true
 puts (%w[ant bear cat].my_all? { |word| word.length >= 4 }) #=> false
# puts %w[ant bear cat].my_all?(/t/) #=> false
# puts [1, 2i, 3.14].my_all?(Numeric) #=> true
# puts [].my_all? #=> true

# puts '5.--------my_any--------'
# puts (%w[ant bear cat].my_any? { |word| word.length >= 3 }) #=> true
# puts (%w[ant bear cat].my_any? { |word| word.length >= 4 }) #=> true
# puts %w[ant bear cat].my_any?(/d/) #=> false
# puts [nil, true, 99].my_any?(Integer) #=> true
# puts [nil, true, 99].my_any? #=> true
# puts [].my_any? #=> false

# puts '6.--------my_none--------'
# puts (%w[ant bear cat].my_none? { |word| word.length == 5 }) #=> true
# puts (%w[ant bear cat].my_none? { |word| word.length >= 4 }) #=> false
# puts %w[ant bear cat].my_none?(/d/) #=> true
# puts [1, 3.14, 42].my_none?(Float) #=> false
# puts [].my_none? #=> true
# puts [nil].my_none? #=> true
# puts [nil, false].my_none? #=> true
# puts [nil, false, true].my_none? #=> false

# puts '7.--------my_count--------'
# arr = [1, 2, 4, 2]
# puts arr.my_count #=> 4
# puts arr.my_count(2) #=> 2
# puts (arr.my_count { |x| (x % 2).zero? }) #=> 3

# puts '8.--------my_maps--------'
# my_order = ['medium Big Mac', 'medium fries', 'medium milkshake']
# puts (my_order.my_map { |item| item.gsub('medium', 'extra large') })
# puts ((0..5).my_map { |i| i * i })
# puts 'my_map_proc'
# my_proc = proc { |i| i * i }
# puts (1..5).my_map(my_proc) { |i| i + i }

# puts '8.--------my_inject--------'
# puts ((1..5).my_inject { |sum, n| sum + n }) #=> 15
# puts (1..5).my_inject(1) { |product, n| product * n } #=> 120
# longest = %w[ant bear cat].my_inject do |memo, word|
#    memo.length > word.length ? memo : word
#  end
#  puts longest #=> "bear"
#  puts 'multiply_els'
#  puts multiply_els([2, 4, 5]) #=> 40
