module Enumerable
  def my_each(array) 
    for item in array do
      yield item
    end
  end
end

[2,3,4].my_each{|x| puts x}


