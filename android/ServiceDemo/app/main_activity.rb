class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    # Create our button to play/stop the music. It is vertically centered.
    layout = Android::Widget::RelativeLayout.new(self)
    layout.gravity = Android::View::Gravity::CENTER
    @button = Android::Widget::Button.new(self)
    @button.text = 'Start'
    @button.onClickListener = self
    @button.minimumWidth = 500
    layout.addView(@button)
    self.contentView = layout

    # Create and connect the broadcast receiver.
    @update_receiver = UpdateReceiver.new
    @update_receiver.delegate = self
    intent_filter = Android::Content::IntentFilter.new(UpdateReceiver::Message)
    intent_filter.addCategory(Android::Content::Intent::CATEGORY_DEFAULT)
    registerReceiver(@update_receiver, intent_filter)
  end

  def onClick(view)
    intent = Android::Content::Intent.new(self, MyService)
    if @started
      # Stop the existing service.
      puts "Stopping service"
      stopService(intent)
      @started = nil
      @button.text = 'Start'
    else
      # Start the service, passing the resource ID of the nyancat.ogg raw file, converted to a String.
      puts "Starting service"
      intent.putExtra(MyService::ResourceToPlay, R::Raw::Nyancat.to_s)
      startService(intent)
      @started = true
    end
  end

  def updateReceived(status)
    # An update from the service via the broadcasting system. Maybe the player is stopped.
    if status >= 1
      @button.text = status.to_s
    else
      @started = nil
      @button.text = 'Start'
    end
  end
end
