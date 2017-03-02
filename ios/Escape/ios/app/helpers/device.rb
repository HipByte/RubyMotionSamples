module Escape
  module Device
    module_function
    # Verifies that the device running the app is an iPhone.
    # @return [TrueClass, FalseClass] true will be returned if the device is an iPhone, false otherwise.
    # copied from BubbleWrap
    def iphone?(idiom=UIDevice.currentDevice.userInterfaceIdiom)
      idiom == UIUserInterfaceIdiomPhone
    end
  end
end
