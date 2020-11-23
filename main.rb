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

  #my_count
  def my_count
    index=0
    for item in self
      index+=1
    end
    index
  end
  #my_none

  #my_map
  def my_map()
    new_arr=[]
    for item in self
      transformed=yield(item)
      new_arr.push(transformed)
    end
    new_arr
  end   
  #my_map

  # my_inject
  def my_inject(sign)
    result = 0 if (sign == :+) || (sign == :-)
    result = 1 if (sign == :*) || (sign == :/)
    for item in self
      result = result.send(sign, item)
    end
    return result
  end
  # my_inject
  def my_map1(proc, &proc1)
    new_arr=[]
    for item in self
      new_item = proc.call(item)
      new_arr << new_item
    end
    new_arr
  end

end

# multiply_els
def multiply_els(array)
  array.my_inject(:*)
end
# multiply_els

#my_map


my_proc = Proc.new{|x| x*10}
#my_map

 test_array = [1, 2, 2]


p test_array.my_map1(my_proc)
p test_array.my_map1{|x| x*100}
# test_array.my_each {|item| p item }
# test_array.my_each_with_index { |item, index| p item, index }
# test_array.my_select {|num| num.even? }
# test_array.my_all? {|num| num.even? }
# test_array.my_none? {|num| num > 5 }
# test_array.my_count
# test_array.my_map{|item| item+2}
# test_array.my_inject(:/)
# multiply_els(test_array)