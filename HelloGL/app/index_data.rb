class IndexData
  attr_accessor :ptr
  
  def initialize(data)
    @num_indices = data.count
    @ptr = Pointer.new(:uchar, @num_indices)
    set_data(data)
  end
  
  def set_data(indices)
    indices.each_with_index do |index,offset|
      @ptr[offset] = index
    end
  end 
  
  def size
    @num_indices
  end 
end