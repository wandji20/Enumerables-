module Enumerable
  # my_each()
  def my_each()
    for item in self do
      yield item if block_given?
    end
  end
  # ending my_each()

  # my_each_with_index()
  def my_each_with_index()
    index = 0
    for item in self do
      yield(item, index) if block_given?
      index += 1
    end
  end
  # my_each_with_index()

  #my_select
  def my_select()
    new_arr = []
    for item in self do
      if yield(item)
        new_arr.push(item)
      end
    end
    return new_arr
  end
  #my_select


  #my_all?
  def my_all?()
    for item in self do
      p feedback = yield(item)
      feedback
    end
  end
  #my_all?



  #my_none?
  def my_none?()
    isNone = true
    for item in self do
      if yield(item)
        isNone = false
      end
    end
    return isNone
  end
  #my_none?
end

test_array = [1, 2, 3, 4, 5]
# test_array.my_each {|item| p item }
# test_array.my_each_with_index { |item, index| p item, index }
# test_array.my_select {|num| num.even? }
# test_array.my_all? {|num| num.even? }
p test_array.my_none? {|num| num > 5 }