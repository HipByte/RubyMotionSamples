class MyService < Android::App::IntentService
  def onHandleIntent(intent)
    puts "MyService created!"

    @player = Android::Media::MediaPlayer.create(self, Com::Yourcompany::Servicedemo::R::Raw::Nyancat)
    @player.looping = true
    @player.start
  end
end
