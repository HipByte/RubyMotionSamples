class AppDelegate < ProMotion::Delegate
  def on_load(app, options)
    open HomeScreen.new(nav_bar: true)
  end
end
