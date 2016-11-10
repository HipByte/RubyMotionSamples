class NotificationController < WKUserNotificationInterfaceController

  def init
    super

    # Initialize variables here.
    # Configure interface objects here.
    NSLog("%@ init", self)

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

  def didReceiveLocalNotification(localNotification, withCompletion:completionHandler)
    # This method is called when a local notification needs to be presented.
    # Implement it if you use a dynamic notification interface.
    # Populate your dynamic notification inteface as quickly as possible.

    # After populating your dynamic notification interface call the completion block.
    completionHandler.call(WKUserNotificationInterfaceTypeCustom)
  end

  def didReceiveRemoteNotification(remoteNotification, withCompletion:completionHandler)
    # This method is called when a remote notification needs to be presented.
    # Implement it if you use a dynamic notification interface.
    # Populate your dynamic notification inteface as quickly as possible.

    # After populating your dynamic notification interface call the completion block.
    completionHandler.call(WKUserNotificationInterfaceTypeCustom)
  end

end
