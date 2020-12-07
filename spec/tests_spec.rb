require './enumerables.rb'

describe Enumerable do
  let(:test_array) { [1, 2, 3] }
  describe '#my_each' do
    it 'Calls the given block once for each element in self' do
      expect(test_array.my_each { |ele| puts ele }).to eql(test_array.each { |ele| puts ele })
    end
  end

  describe '#my_each_with_index()' do
    it 'Calls the given block once for each element in self with its index' do
      expect(test_array.my_each_with_index { |ele, index|puts ele if index.even? }).to eql(test_array.each_with_index do |ele, index|puts ele if index.even?end)
    end
  end

  describe '#my_select()' do
    it 'Returns a new array containing all elements of ary for which the given block returns a true value' do
      expect(test_array.my_select { |ele| ele if ele != 2 }).to eql(test_array.select { |ele| ele if ele != 2 })
    end
  end

  describe '#my_all?()' do
    it 'Returns True if all elements in an array pass the given block' do
      expect(test_array.my_all?{ |ele| ele > 100 }).to eql(test_array.all? { |ele| ele > 100 })
    end
  end

end
