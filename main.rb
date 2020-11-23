module Enumerable
  # my_each()
  def my_each()
    each do |item|
      yield item if block_given?
    end
  end
  # ending my_each()

  # my_each_with_index()
  def my_each_with_index()
    index = 0
    each do |item|
      yield(item, index) if block_given?
      index += 1
    end
  end
  # my_each_with_index()

  # my_select
  def my_select()
    new_arr = []
    each do |item|
      new_arr << item if yield(item)
    end
    new_arr
  end
  # my_select

  # my_all?
  def my_all?()
    flag = true
    each do |item|
      feedback = yield(item)
      flag = false if (feedback == false) || (feedback == nil)
    end
    return flag
  end
  # my_all?

  # my_any
  def my_any?()
    flag = false
    each do |item|
      flag = true if yield(item)
    end
    flag
  end
  # my_any

  # my_none?
  def my_none?()
    isNone = true
    each do |item|
      isNone = false if yield(item)
    end
    isNone
  end
  # my_none?

  # my_count
  def my_count
    index = 0
    each do |_item|
      index += 1
    end
    index
  end
  # my_count

  # my_map
  def my_map(proc = nil, &block)
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
  # my_map

  # my_inject
  def my_inject(sign)
    result = 0 if (sign == :+) || (sign == :-)
    result = 1 if (sign == :*) || (sign == :/)
    each do |item|
      result = result.send(sign, item)
    end
    result
  end
  # my_inject
end

# multiply_els
def multiply_els(array)
  array.my_inject(:*)
end

# my_proc = Proc.new { |x| x*10 }
#test_array = [1, 2, 2]
# test_array.my_each {|item| p item }
# test_array.my_each_with_index { |item, index| p item, index }
# test_array.my_select {|num| num.even? }
# test_array.my_all? {|num| num<4 }
# test_array.my_any? {|num| num==1}
# test_array.my_none? {|num| num > 5 }
# test_array.my_count
# test_array.my_map{|item| item+2}
# test_array.my_map(my_proc)
# test_array.my_inject(:/)
# multiply_els(test_array)
