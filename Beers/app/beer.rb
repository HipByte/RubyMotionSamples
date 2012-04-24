class Beer
  def initialize(lat, long, name, link)
    @name = name
    @coordinate = CLLocationCoordinate2D.new
    @coordinate.latitude = lat
    @coordinate.longitude = long
    @url = NSURL.alloc.initWithString(link)
  end

  def title; @name; end
  def coordinate; @coordinate; end
  def url; @url; end

  All = [
    Beer.new(50.016667, 4.316667, 'Chimay', 'http://en.wikipedia.org/wiki/Chimay_Brewery'),
    Beer.new(49.639722, 5.348889, 'Orval', 'http://en.wikipedia.org/wiki/Orval_Brewery'),
    Beer.new(50.178162, 5.219879, 'Rochefort', 'http://en.wikipedia.org/wiki/Rochefort_Brewery'),
    Beer.new(51.284720, 4.656670, 'Westmalle', 'http://en.wikipedia.org/wiki/Westmalle_Brewery'),
    Beer.new(50.895942, 2.721262, 'Westvleteren', 'http://en.wikipedia.org/wiki/Westvleteren_Brewery'),
    Beer.new(51.298800, 5.488570, 'Achel', 'http://en.wikipedia.org/wiki/Achel_Brewery')
  ]
end
