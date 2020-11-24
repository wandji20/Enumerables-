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
    each do |item|
      yield(item, index) if block_given?
      index += 1
    end
  end

  # my_select
  def my_select()
    return to_enum(:my_select) unless block_given?

    new_arr = []
    each do |item|
      new_arr << item if yield(item)
    end
    new_arr
  end

  # my_all?
  def my_all?(arg = nil)
    flag = true
    case arg
    when arg.instance_of?(Class)
      each { |item| flag = false unless item.is_a? arg }
      return flag
    when arg.instance_of?(Regexp)
      each { |item| flag = false if arg.match(item.to_s).nil? }
      return flag
    when arg.instance_of?(String)
      each {|item| flag = false unless item.include? arg}
      return flag
    when block_given?
      each do |item|
        feedback = yield(item)
        flag = false if (feedback == false) || feedback.nil?
      end
      return flag
    when !(block_given?)
      arg = proc { |obj| obj }
      each do |item|
        feedback = arg.call(item)
        flag = false if (feedback == false) || feedback.nil?
      end
      flag
    end
  
    #if arg.instance_of?(Class)
    #  each { |item| flag = false unless item.is_a? arg }
    #  return flag
    #elsif arg.instance_of?(Regexp)
    #  each { |item| flag = false if arg.match(item.to_s).#nil? }
    #  return flag
    #elsif arg.instance_of?(String)
    #  each {|item| flag = false unless item.include? arg}
    #  return flag
    #elsif block_given?
    #  each do |item|
    #    feedback = yield(item)
    #    flag = false if (feedback == false) || feedback.nil?
    #  end
    #  return flag
    #end
    #unless block_given?
    #  arg = proc { |obj| obj }
    #  each do |item|
    #    feedback = arg.call(item)
    #    flag = false if (feedback == false) || feedback.nil?
    #  end
    #  flag
    #end
  end

  # my_any?
  def my_any?(arg = nil)
    flag = false
    if arg.instance_of?(Class)
      each do |item|
        flag = true if item.is_a? arg
      end
      return flag
    elsif arg.instance_of?(Regexp)
      each do |item|
        flag = true unless arg.match(item.to_s).nil?
      end
      return flag
    elsif arg.instance_of?(String)
      each do |item|
        flag = true if item.to_s.include? arg
      end
      return flag
    elsif block_given?
      each do |item|
        flag = true if yield(item)
      end
      return flag
    end
    unless block_given?
      flag = true
      arg = proc { |obj| obj }
      each do |item|
        flag = false if (arg.call(item) == false) || arg.call(item).nil?
      end
      flag
    end
  end

  # my_none?
  def my_none?(arg = nil)
    flag = true
    if arg.instance_of?(Class)
      each do |item|
        flag = false if item.is_a? arg
      end
      return flag
    elsif arg.instance_of?(Regexp)
      each do |item|
        flag = false if arg.match(item)
      end
      return flag
    elsif arg.instance_of?(String)
      each do |item|
        flag = false if item.to_s.include? arg
      end
      return flag
    elsif block_given?
      each do |item|
        flag = true if yield(item)
      end
      return flag
    end
    unless block_given?
      arg = proc { |obj| obj }
      each do |item|
        flag = false if arg.call(item)
      end
      flag
    end
  end

  # my_count
  def my_count(arg = nil)
    counter = 0
    if arg
      each do |item|
        counter += 1 if item == arg
      end
    elsif block_given?
      each do |item|
        counter += 1 if yield(item)
      end
    else
      each do
        counter += 1
      end
    end
    counter
  end

  # my_map
  def my_map(proc = nil, &block)
    return to_enum(:my_map) unless block_given?

    new_arr = []
    if proc.is_a? Proc
      each do |item|
        new_item = proc.call(item)
        new_arr << new_item
      end
      return new_arr
    end

    each do |item|
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
      each do |item|
        result = result.send(sign, item)
      end
    elsif init.is_a?(Symbol) && sign.nil?
      result = first
      each do |item|
        result = result.send(init, item)
      end
    elsif block_given?
      result = init || first
      for i in (1..length-1) 
        result = yield(result, self[i])
      end
      #each do |item|
        #result = yield(result, item)
      #end
      
    elsif my_all?(String)
      longst_word = 0
      each do |item|
        longst_word = item.length if item.length > longst_word
      end
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
# test_array = ['abc','defg','hijk','lmnop']
# test_array = ['abc', 123, 'hijk', 'lmnop']
# my_proc = Proc.new { |x| x * 10 }

#############################################

# p test_array.my_each
# p test_array.my_each_with_index { |item, index| p item, index }
# p test_array.my_select {|num| num.even? }
# p test_array.my_all? (/2/)
# p test_array.my_any?(/0/)
# p test_array.my_none?(/z/)
# p test_array.my_count { |ele| ele.is_a? String }
# p test_array.my_map { |x| x * 100 }
# p test_array.my_map(my_proc) { |x| puts x * 100 }
# test_array.my_inject { |sum, n| sum * n }
# p multiply_els(test_array)
# test_array.inject { |sum, n| sum + n }


