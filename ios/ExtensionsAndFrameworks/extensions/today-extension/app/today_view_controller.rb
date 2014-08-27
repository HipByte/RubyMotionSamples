class TodayViewController < UIViewController

  def viewDidLoad
    super

    label = UILabel.alloc.init
    label.text = "Hello World"
    label.textColor = UIColor.whiteColor
    label.textAlignment = NSTextAlignmentCenter
    label.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addSubview(label)

    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[label]-|", options:0, metrics:nil, views:{"label" => label}))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]-|", options:0, metrics:nil, views:{"label" => label}))

    MyFrameworkClass.say_hello
  end

  def didReceiveMemoryWarning
    super
    # Dispose of any resources that can be recreated.
  end

  def widgetPerformUpdateWithCompletionHandler(completionHandler)
    # Perform any setup necessary in order to update the view.

    # If an error is encoutered, use NCUpdateResultFailed
    # If there's no update required, use NCUpdateResultNoData
    # If there's an update, use NCUpdateResultNewData

    completionHandler.call(NCUpdateResultNewData)
  end

end
