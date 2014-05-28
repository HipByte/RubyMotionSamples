class TimerButtonListener < Java::Lang::Object
  def set_activity(activity)
    @activity = activity
  end

  def onClick(view)
    @activity.toggleTimer
  end
end

class TimerTask < Java::Util::TimerTask
  def set_activity(activity)
    @activity = activity
  end

  def run
    @activity.handler.post -> { @activity.updateTimer }
  end
end

class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super
    @handler = Android::Os::Handler.new

    layout = Android::Widget::LinearLayout.new(self)
    layout.orientation = Android::Widget::LinearLayout::VERTICAL

    @label = Android::Widget::TextView.new(self)
    @label.text = 'Tap to start'
    @label.textSize = 80.0
    @label.gravity = Android::View::Gravity::CENTER_HORIZONTAL
    layout.addView(@label)

    @button = Android::Widget::Button.new(self)
    @button.text = 'Start'
    listener = TimerButtonListener.new
    listener.set_activity self
    @button.onClickListener = listener
    layout.addView(@button)

    self.contentView = layout
  end

  def handler
    @handler
  end

  def toggleTimer
    if @timer
      @timer.cancel
      @timer = nil
      @button.text = 'Start'
    else
      @timer = Java::Util::Timer.new
      @counter = 0
      task = TimerTask.new
      task.set_activity self
      @timer.schedule task , 0, 100
      @button.text = 'Stop'
    end
  end

  def updateTimer
    @label.text = "%.1f" % (@counter += 0.1)
  end
end

