class Tracker
  URL = NSURL.URLWithString("https://api.bitcoinaverage.com/ticker/USD")

  def self.dateFormatter
    @dateFormatter ||= NSDateFormatter.new.tap { |df| df.dateFormat = 'HH:mm' }
  end

  def self.priceFormatter
    @priceFormatter ||= begin
      formatter = NSNumberFormatter.new
      formatter.currencyCode = 'USD'
      formatter.numberStyle = NSNumberFormatterCurrencyStyle
      formatter
    end
  end

  def initialize
    config = NSURLSessionConfiguration.defaultSessionConfiguration
    @session = NSURLSession.sessionWithConfiguration(config)
  end

  def defaults
    NSUserDefaults.standardUserDefaults
  end

  def cachedDate
    defaults['date'] || NSDate.date
  end

  def cachedPrice
    defaults['price'] || 0
  end

  def requestPrice(&completionBlock)
    request = NSURLRequest.requestWithURL(URL)
    task = @session.dataTaskWithRequest(request,
                      completionHandler:lambda { |data, response, error|
      if error.nil?
        jsonError = Pointer.new(:object)
        responseDict = NSJSONSerialization.JSONObjectWithData(data,
                                                      options:0,
                                                        error:jsonError)
        if jsonError[0].nil?
          price = responseDict['24h_avg']
          defaults['price'] = price
          defaults['date'] = NSDate.date
          defaults.synchronize
          Dispatch::Queue.main.async do
            completionBlock.call(price, nil)
          end
        else
          Dispatch::Queue.main.async do
            completionBlock.call(nil, jsonError[0])
          end
        end
      else
        Dispatch::Queue.main.async do
          completionBlock.call(nil, error)
        end
      end
    })
    task.resume
  end
end

class InterfaceController < WKInterfaceController
  extend IB

  outlet :priceLabel, WKInterfaceLabel
  outlet :lastUpdatedLabel, WKInterfaceLabel
  outlet :image, WKInterfaceImage

  def awakeWithContext(context)
    super

    @image.hidden = true
    @tracker = Tracker.new
    updatePrice(@tracker.cachedPrice)
    updateDate(@tracker.cachedDate)

    self
  end

  def willActivate
    super
    update
  end

  def refreshTapped(sender)
    update
  end

  def update
    unless @updating
      @updating = true
      originalPrice = @tracker.cachedPrice
      @tracker.requestPrice do |newPrice, error|
        if error.nil?
          updatePrice(newPrice)
          updateDate(NSDate.date)
          updateImage(originalPrice, newPrice)
        end
        @updating = false
      end
    end
  end

  def updatePrice(price)
    @priceLabel.text = Tracker.priceFormatter.stringFromNumber(price)
  end

  def updateDate(date)
    formattedDate = Tracker.dateFormatter.stringFromDate(date)
    @lastUpdatedLabel.text = "Last Updated #{formattedDate}"
  end

  def updateImage(originalPrice, newPrice)
    # Normally one shouldn’t compare floats directly, but it works for this
    # contrived example.
    if originalPrice == newPrice
      @image.hidden = true
    else
      if newPrice > originalPrice
        @image.imageNamed = 'Up'
      else
        @image.imageNamed = 'Down'
      end
      @image.hidden = false
    end
  end

  def didDeactivate
    super
  end

end
