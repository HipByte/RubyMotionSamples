class Photo
  attr_reader :url, :link
  
  def initialize(url, link)
    @urlString = url
    @url = NSURL.alloc.initWithString(url)
    @link = NSURL.alloc.initWithString(link)
  end
  
  # IKImageBrowserItem protocol.
  
  def imageUID
    @urlString
  end
    
  def imageRepresentationType
    :IKImageBrowserNSImageRepresentationType
  end
  
  PhotoDownloadFinishedNotification = 'PhotoDownloadFinishedNotification'

  def imageRepresentation    
    @image ||= begin
      Dispatch::Queue.concurrent.async do
        @image = NSImage.alloc.initWithContentsOfURL(@url)
        Dispatch::Queue.main.sync { NSNotificationCenter.defaultCenter.postNotificationName(PhotoDownloadFinishedNotification, object:self) }
      end
    end
  end
end
