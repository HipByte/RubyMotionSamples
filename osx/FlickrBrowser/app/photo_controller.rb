class PhotoController
  def initialize(window)
    @browserView = IKImageBrowserView.alloc.initWithFrame(window.contentView.bounds)
    @browserView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
    window.contentView.addSubview(@browserView)

    #@browserView.animates = true
    @browserView.dataSource = self
    @browserView.delegate = self

    NSNotificationCenter.defaultCenter.addObserver self,
      selector:'feedRefreshed:',
      name:PSFeedRefreshingNotification,
      object:nil
  end

  def searchImages(tag)
    url = "http://api.flickr.com/services/feeds/photos_public.gne?tags=#{tag}&lang=en-us&format=rss_200".stringByAddingPercentEscapesUsingEncoding NSUTF8StringEncoding
    @feed = PSFeed.alloc.initWithURL(NSURL.URLWithString(url))
    @feed.refresh(nil)
  end

  def feedRefreshed(notification)
    feed = notification.object
    @results = feed.entryEnumeratorSortedBy(nil).allObjects
    @cache = []
    @browserView.reloadData
  end

  def numberOfItemsInImageBrowser(browser)
    @results ? @results.size : 0
  end

  def imageBrowser(browser, itemAtIndex:index)
    photo = @cache[index]
    if photo.nil? 
      entry = @results[index]
      html = entry.content.HTMLString
      link = html.scan(/<a\s+href="([^"]+)" title/)[0][0]
      url = html.scan(/<img\s+src="([^"]+)"/)[0][0]
      photo = Photo.new(url, link)
      @cache[index] = photo
    end
    return photo
  end

  def imageBrowser(browser, cellWasDoubleClickedAtIndex:index)
    NSWorkspace.sharedWorkspace.openURL @cache[index].link
  end
end
