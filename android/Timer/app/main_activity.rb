class TimerButtonListener
  attr_accessor :activity

  def onClick(view)
    @activity.toggleTimer
  end
end

class TimerTask < Java::Util::TimerTask
  attr_accessor :activity

  def run
    # This method will be called from another thread, and UI work must
    # happen in the main thread, so we dispatch it via a Handler object.
    @activity.handler.post -> { @activity.updateTimer }
  end
end

class MainActivity < Android::App::Activity
  attr_reader :handler

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
    listener.activity = self
    @button.onClickListener = listener
    layout.addView(@button)

    self.contentView = layout
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
      task.activity = self
      @timer.schedule task , 0, 100
      @button.text = 'Stop'
    end
  end

  def updateTimer
    @label.text = "%.1f" % (@counter += 0.1)
  end
end

