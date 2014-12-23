class RequestListener
  attr_accessor :activity

  def initialize(activity)
    @activity = activity
  end

  def onResponse(json)
    weather = Weather.new(json)
    @activity.update_display(weather)
  end
end
