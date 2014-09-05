module MyFrameworkModule
  def say_hello
    NSLog("Hello from the framework")
  end
end

class MyFrameworkClass
  extend MyFrameworkModule
end
