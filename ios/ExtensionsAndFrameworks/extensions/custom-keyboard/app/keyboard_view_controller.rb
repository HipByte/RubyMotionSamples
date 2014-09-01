class KeyboardViewController < UIInputViewController

  attr_accessor :nextKeyboardButton

  def updateViewConstraints
    super
    # Add custom view sizing constraints here
  end

  def viewDidLoad
    super

    # Perform custom UI setup here
    self.nextKeyboardButton = UIButton.buttonWithType(UIButtonTypeSystem)

    self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", "Title for 'Next Keyboard' button"), forState:UIControlStateNormal)
    self.nextKeyboardButton.sizeToFit
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false

    self.nextKeyboardButton.addTarget(self, action:"advanceToNextInputMode", forControlEvents:UIControlEventTouchUpInside)

    self.view.addSubview(self.nextKeyboardButton)

    nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint.constraintWithItem(self.nextKeyboardButton, attribute:NSLayoutAttributeLeft, relatedBy:NSLayoutRelationEqual, toItem:self.view, attribute:NSLayoutAttributeLeft, multiplier:1.0, constant:0.0)
    nextKeyboardButtonBottomConstraint = NSLayoutConstraint.constraintWithItem(self.nextKeyboardButton, attribute:NSLayoutAttributeBottom, relatedBy:NSLayoutRelationEqual, toItem:self.view, attribute:NSLayoutAttributeBottom, multiplier:1.0, constant:0.0)
    self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])

    MyFrameworkClass.say_hello
  end

  def didReceiveMemoryWarning
    super
    # Dispose of any resources that can be recreated
  end

  def textWillChange(textInput)
    # The app is about to change the document's contents. Perform any preparation here.
  end

  def textDidChange(textInput)
    # The app has just changed the document's contents, the document context has been updated.

    textColor = nil
    if self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark
        textColor = UIColor.whiteColor
    else
        textColor = UIColor.blackColor
    end
    self.nextKeyboardButton.setTitleColor(textColor, forState:UIControlStateNormal)
  end

end
