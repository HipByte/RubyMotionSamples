class TimerController < UIViewController
  attr_reader :timer

  def viewDidLoad
    margin = 500

    @state = UILabel.new
    @state.font = UIFont.systemFontOfSize(90)
    @state.text = 'Push to start'
    @state.textAlignment = UITextAlignmentCenter
    @state.textColor = UIColor.darkGrayColor
    @state.backgroundColor = UIColor.clearColor
    @state.frame = [[margin, 200], [view.frame.size.width - margin * 2, 100]]
    view.addSubview(@state)

    @action = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @action.setTitle('Push', forState:UIControlStateNormal)
    @action.addTarget(self, action:'actionTapped', forControlEvents:UIControlEventPrimaryActionTriggered)
    @action.frame = [[margin, 400], [view.frame.size.width - margin * 2, 100]]
    view.addSubview(@action)
  end

  def actionTapped
    if @timer
      @timer.invalidate
      @timer = nil
    else
      @duration = 0
      @timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:'timerFired', userInfo:nil, repeats:true)
    end
  end

  def timerFired
    @state.text = "%.1f" % (@duration += 0.1)
  end
end
