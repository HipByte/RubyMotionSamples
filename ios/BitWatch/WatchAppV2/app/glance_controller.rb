class GlanceController < WKInterfaceController

  def awakeWithContext(context)
    super

    # Initialize variables here.
    # Configure interface objects here.
    NSLog("%@ awakeWithContext", self)

    self
  end

  def willActivate
    # This method is called when watch view controller is about to be visible to user
    NSLog("%@ will activate", self)
    super
  end

  def didDeactivate
    # This method is called when watch view controller is no longer visible
    NSLog("%@ did deactivate", self)
    super
  end

end
