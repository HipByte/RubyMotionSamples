class RSSParser
  def initWithDelegate(delegate, URL:url)
    @delegate = delegate
    @url = url
    self
  end

  def parse
    @nsurl = NSURL.URLWithString(@url)
    @self = self
    Dispatch::Queue.concurrent.async do
      xml = NSXMLParser.alloc.initWithContentsOfURL(@nsurl)
      xml.delegate = @self
      xml.parse
    end
  end

  def parserDidStartDocument(parser)
    @item = {}
  end

  def parserDidEndDocument(parser)
    if @delegate.respond_to?("parserDidEndDocument")
      Dispatch::Queue.main.sync do
        @delegate.send("parserDidEndDocument")
      end
    end
  end

  def parser(parser,
             didStartElement: elementName,
             namespaceURI: namespaceURI,
             qualifiedName: qualifiedName,
             attributes: attributeDict)
    @string = ""
  end

  def parser(parser,
             didEndElement: elementName,
             namespaceURI: namespaceURI,
             qualifiedName: qName)
    @item[elementName] = @string
    if elementName == "item"
      if @delegate.respond_to?("parserDidEndItem")
        Dispatch::Queue.main.sync do
          @delegate.send("parserDidEndItem", @item)
        end
      end
      @item = {}
    end
  end

  def parser(parser,
             foundCharacters: string)
    @string << string.strip
  end
end
