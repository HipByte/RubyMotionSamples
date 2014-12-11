class NotificationController < WKUserNotificationInterfaceController

  def init
    super

    NSLog("%@ init", self)

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

  def didReceiveLocalNotification(localNotification, withCompletion:completionHandler)
    # This method is called when a local notification needs to be presented.
    # Implement it if you use a dynamic notification interface.
    # Populate your dynamic notification inteface as quickly as possible.

    # After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom)
  end

  def didReceiveRemoteNotification(remoteNotification, withCompletion:completionHandler)
    # This method is called when a remote notification needs to be presented.
    # Implement it if you use a dynamic notification interface.
    # Populate your dynamic notification inteface as quickly as possible.

    # After populating your dynamic notification interface call the completion block.
    completionHandler(WKUserNotificationInterfaceTypeCustom)
  end

end
