### ### ### ### ### ### ### ### ### ### ###
#        Ruby         #         By        #
#      Project 2      #     @wandji20     #
#     Enumerables     #     @od-c0d3r     #
###  ###  ####  ### ### ### ### ### ### ###

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
    end
    if block_given? && arg.nil?
      my_each { |item| flag = true if yield(item) }
    elsif !block_given? && arg.nil?
      flag = true
      arg = proc { |obj| obj }
      my_each { |item| flag = false if (arg.call(item) == false) || arg.call(item).nil? }
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
    end
    if block_given? && arg.nil?
      my_each { |item| flag = true if yield(item) }
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

    return LocalJumpError unless block_given? || sign || init || my_all?(String)
    if init && sign
      result = init
      my_each { |item| result = result.send(sign, item) }
    elsif init.is_a?(Symbol) && sign.nil?
      result = first
      my_each { |item| result = result.send(init, item) }
    elsif block_given?
      result = init || first
      (1..length - 1).each { |i| result = yield(result, self[i]) }
    elsif my_all?(String)
      longst_word = 0
      my_each { |item| longst_word = item.length if item.length > longst_word }
      return longst_word
    end
    result
  end

  # end Module
end

# multiply_els to test #my_inject
def multiply_els(array)
  array.my_inject(:*)
end

### ### ### ### ###
#                 #
#   Code Testing  #
#                 #
###  ###  ####  ###

# test_array = [1, 2, 3,5]
# test_array = %w[a21bc de21fg hi12jk lm12nop]
# test_array = ['abc', 123, 'hijk', 'lmnop']
# my_proc = Proc.new { |x| x * 10 }

#############################################

# p test_array.my_each
# p test_array.my_each_with_index { |item, index| p item, index }
# p test_array.my_select {|num| num.even? }
# p test_array.my_all? { |ele| ele.length < 100 }
# p test_array.my_any?(/0/)
# p test_array.my_none?(/a/)
# p test_array.my_count { |ele| ele.is_a? String }
# p test_array.my_map { |x| x * 100 }
# p test_array.my_map(my_proc) { |x| puts x * 100 }
# p test_array.my_inject { |sum, n| sum * n }
# p multiply_els(test_array)
# test_array.inject { |sum, n| sum + n }
