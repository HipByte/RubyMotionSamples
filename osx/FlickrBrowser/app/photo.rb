class Photo
  attr_reader :url, :link
  
  def initialize(url, link)
    @urlString = url
    @url = NSURL.alloc.initWithString url
    @link = NSURL.alloc.initWithString link
  end
  
  # IKImageBrowserItem protocol conformance
  
  def imageUID
    @urlString
  end
    
  def imageRepresentationType
    :IKImageBrowserNSImageRepresentationType
  end
  
  def imageRepresentation    
    @image ||= NSImage.alloc.initByReferencingURL @url
  end
end
