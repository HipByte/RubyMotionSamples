class JSONParser
  def self.parse_from_url(url)
    data = DataParser.parse(url)
    
    error_ptr = Pointer.new(:object)
    json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
    unless json
      raise error_ptr[0]
    end
    json
  end
end
