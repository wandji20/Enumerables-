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
# p multiply_els([1,2,3]) == 6
# p (1..3).my_inject() { |total, num| total*num }
# # p (1..3).inject(&proc{|total, num| total*num})
# test_array = [1,2,3,10]
# p (1..3).inject(&proc{|total, num| total*num}) == (1..3).my_inject(&proc{|total, num| total*num})
# p test_array.my_each
# p [1, 2, 3, 4].my_each_with_index
# p test_array.my_select {|num| num.even? }
# p test_array.my_all?(1)
# p test_array.my_any?
# p test_array.my_none?(3)
# p [1, 2, 3, 4].my_inject(10) { |accum, elem| accum + elem }
# p test_array.my_count { |ele| ele.is_a? String }
# p test_array.my_map { |x| x * 100 }
# p test_array.my_map(my_proc) { |x| puts x * 100 }
# p test_array.my_inject { |sum, n| sum * n }
# p (1..5).my_inject("-")
# p multiply_els(test_array)
# puts 'my_inject'
# puts '---------'
# p [1, 2, 3, 4].my_inject(10) { |accum, elem| accum + elem } # => 20
# [1, 2, 3, 4].my_inject { |accum, elem| accum + elem } # => 10
# (1..4).my_inject { |accum, elem| accum + elem }
# p [5, 1, 2].my_inject('+') # => 8
# p (5..10).my_inject(2, :*) # should return 302400
# p (5..10).my_inject(4) { |prod, n| prod * n } # should return 604800
# p [1, 2, 3, 4].my_inject
###############################
