class GlanceController < WKInterfaceController

  def initWithContext(context)
    super

    # Initialize variables here.
    # Configure interface objects here.
    NSLog("%@ initWithContext", self)

    return self;
  end

  def willActivate
    # This method is called when watch view controller is about to be visible to user
    NSLog("%@ will activate", self)
  end

  def didDeactivate
    # This method is called when watch view controller is no longer visible
    NSLog("%@ did deactivate", self)
  end

end
