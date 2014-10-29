class MyService < Android::App::IntentService
  ResourceToPlay = 'MyServiceResourceToPlay'
  UpdateStatus = "MyServiceUpdateStatus"
  Delay = 5

  def onHandleIntent(intent)
    # Retrieve the resource to play, we get a String object and we need to convert it to an Integer.
    resource_str = intent.getStringExtra(ResourceToPlay)
    raise "ResourceToPlay not provided" unless resource_str
    resource = Java::Lang::Integer.new(resource_str)

    # Start the media player with the resource.
    puts "Playing NYANCAT for #{Delay} seconds :)"
    @player = Android::Media::MediaPlayer.create(self, resource)
    @player.looping = true
    @player.start

    # Block the current thread for 5 seconds. Each second, we broadcast a message.
    n = Delay
    while n >= 0
      break unless @player.playing?
      broadcast_intent = Android::Content::Intent.new
      broadcast_intent.action = UpdateReceiver::Message
      broadcast_intent.addCategory(Android::Content::Intent::CATEGORY_DEFAULT)
      broadcast_intent.putExtra(UpdateStatus, n.to_s)
      sendBroadcast(broadcast_intent)
      break if n == 0
      n -= 1
      sleep 1
    end
  end

  def onDestroy
    # This method is called if the #sleep call in onHandleIntent is over or if the main activity stops our service.
    puts "No more NYANCAT :("
    @player.stop
    super
  end
end
