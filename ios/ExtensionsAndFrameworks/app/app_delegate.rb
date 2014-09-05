class AppDelegate
  include MyFrameworkModule

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    MyFrameworkClass.say_hello
    say_hello # Included from the module
    true
  end
end
