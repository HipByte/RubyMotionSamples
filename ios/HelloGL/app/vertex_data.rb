class VertexData
  attr_accessor :ptr
  
  def initialize(data)
    @vertex_size = data[0].count
    @num_vertices = data.count
    @ptr = Pointer.new(:float, @vertex_size * @num_vertices)
    set_data(data)
  end
  
  def set_data(vertices)
    vertices.each_with_index do |vertex,idx|
      vertex.each_with_index do |component, component_idx|
        @ptr[idx * @vertex_size + component_idx] = component
      end
    end
  end  
  
  def size
    @vertex_size * @num_vertices
  end
end