class KeyboardViewController < UIInputViewController

  attr_accessor :nextKeyboardButton
  attr_accessor :decodedField

  MORSE_CODE = {
    '.-' =>    'a',
    '-...' =>  'b',
    '-.-.' =>  'c',
    '-..' =>   'd',
    '.' =>     'e',
    '..-.' =>  'f',
    '--.' =>   'g',
    '....' =>  'h',
    '..' =>    'i',
    '.---' =>  'j',
    '-.-' =>   'k',
    '.-..' =>  'l',
    '--' =>    'm',
    '-.' =>    'n',
    '---' =>   'o',
    '.--.' =>  'p',
    '--.-' =>  'q',
    '.-.' =>   'r',
    '...' =>   's',
    '-' =>     't',
    '..-' =>   'u',
    '...-' =>  'v',
    '.--' =>   'w',
    '-..-' =>  'x',
    '-.--' =>  'y',
    '--..' =>  'z',
    '.----' => '1',
    '..---' => '2',
    '...--' => '3',
    '....-' => '4',
    '.....' => '5',
    '-....' => '6',
    '--...' => '7',
    '---..' => '8',
    '----.' => '9',
    '-----' => '0',
  }

  def viewDidLoad
    super

    dotButton = UIButton.buttonWithType(UIButtonTypeSystem)
    dotButton.setTitle('.', forState: UIControlStateNormal)
    dotButton.translatesAutoresizingMaskIntoConstraints = false
    dotButton.addTarget(self, action: 'didTapDot', forControlEvents: UIControlEventTouchUpInside)
    dotButton.titleLabel.font = UIFont.systemFontOfSize(32)
    dotButton.titleLabel.textColor = UIColor.whiteColor
    dotButton.backgroundColor = UIColor.colorWithWhite(0.1, alpha: 0.1)
    dotButton.layer.cornerRadius = 5
    dotButtonCenterXConstraint = NSLayoutConstraint.constraintWithItem(dotButton,
      attribute: NSLayoutAttributeRight,
      relatedBy: NSLayoutRelationEqual,
      toItem: self.view, attribute: NSLayoutAttributeCenterX,
      multiplier: 1.0, constant: -4.0)
    dotButtonCenterYConstraint = NSLayoutConstraint.constraintWithItem(dotButton,
      attribute: NSLayoutAttributeCenterY,
      relatedBy: NSLayoutRelationEqual,
      toItem: self.view, attribute: NSLayoutAttributeCenterY,
      multiplier: 1.0, constant: 0.0)

    self.view.addSubview(dotButton)
    self.view.addConstraints([dotButtonCenterXConstraint, dotButtonCenterYConstraint])

    dashButton = UIButton.buttonWithType(UIButtonTypeSystem)
    dashButton.setTitle('–', forState: UIControlStateNormal)
    dashButton.translatesAutoresizingMaskIntoConstraints = false
    dashButton.addTarget(self, action: 'didTapDash', forControlEvents: UIControlEventTouchUpInside)
    dashButton.titleLabel.font = UIFont.systemFontOfSize(32)
    dashButton.titleLabel.textColor = UIColor.whiteColor
    dashButton.backgroundColor = UIColor.colorWithWhite(0.1, alpha: 0.1)
    dashButton.layer.cornerRadius = 5
    dashButtonCenterXConstraint = NSLayoutConstraint.constraintWithItem(dashButton,
      attribute: NSLayoutAttributeLeft,
      relatedBy: NSLayoutRelationEqual,
      toItem: self.view, attribute: NSLayoutAttributeCenterX,
      multiplier: 1.0, constant: 4.0)
    dashButtonCenterYConstraint = NSLayoutConstraint.constraintWithItem(dashButton,
      attribute: NSLayoutAttributeCenterY,
      relatedBy: NSLayoutRelationEqual,
      toItem: self.view, attribute: NSLayoutAttributeCenterY,
      multiplier: 1.0, constant: 0.0)

    self.view.addSubview(dashButton)
    self.view.addConstraints([dashButtonCenterXConstraint, dashButtonCenterYConstraint])

    spaceButton = UIButton.buttonWithType(UIButtonTypeSystem)
    spaceButton.setTitle('⌴', forState: UIControlStateNormal)
    spaceButton.translatesAutoresizingMaskIntoConstraints = false
    spaceButton.addTarget(self, action: 'didTapSpace', forControlEvents: UIControlEventTouchUpInside)
    spaceButton.titleLabel.font = UIFont.systemFontOfSize(32)
    spaceButton.titleLabel.textColor = UIColor.whiteColor
    spaceButton.backgroundColor = UIColor.colorWithWhite(0.1, alpha: 0.1)
    spaceButton.layer.cornerRadius = 5
    spaceButtonRightConstraint = NSLayoutConstraint.constraintWithItem(spaceButton,
      attribute: NSLayoutAttributeRight,
      relatedBy: NSLayoutRelationEqual,
      toItem: dotButton, attribute: NSLayoutAttributeLeft,
      multiplier: 1.0, constant: -8.0)
    spaceButtonCenterYConstraint = NSLayoutConstraint.constraintWithItem(spaceButton,
      attribute: NSLayoutAttributeCenterY,
      relatedBy: NSLayoutRelationEqual,
      toItem: self.view, attribute: NSLayoutAttributeCenterY,
      multiplier: 1.0, constant: 0.0)

    self.view.addSubview(spaceButton)
    self.view.addConstraints([spaceButtonRightConstraint, spaceButtonCenterYConstraint])

    bkspButton = UIButton.buttonWithType(UIButtonTypeSystem)
    bkspButton.setTitle('⌫', forState: UIControlStateNormal)
    bkspButton.translatesAutoresizingMaskIntoConstraints = false
    bkspButton.addTarget(self, action: 'didTapDelete', forControlEvents: UIControlEventTouchUpInside)
    bkspButton.titleLabel.font = UIFont.systemFontOfSize(32)
    bkspButton.titleLabel.textColor = UIColor.whiteColor
    bkspButton.backgroundColor = UIColor.colorWithWhite(0.1, alpha: 0.1)
    bkspButton.layer.cornerRadius = 5
    bkspButtonLeftConstraint = NSLayoutConstraint.constraintWithItem(bkspButton,
      attribute: NSLayoutAttributeLeft,
      relatedBy: NSLayoutRelationEqual,
      toItem: dashButton, attribute: NSLayoutAttributeRight,
      multiplier: 1.0, constant: 8.0)
    bkspButtonCenterYConstraint = NSLayoutConstraint.constraintWithItem(bkspButton,
      attribute: NSLayoutAttributeCenterY,
      relatedBy: NSLayoutRelationEqual,
      toItem: self.view, attribute: NSLayoutAttributeCenterY,
      multiplier: 1.0, constant: 0.0)

    self.view.addSubview(bkspButton)
    self.view.addConstraints([bkspButtonLeftConstraint, bkspButtonCenterYConstraint])

    @decodedField = UILabel.alloc.initWithFrame([[4, 4], [self.view.bounds.size.width - 8, 38]])
    @decodedField.autoresizingMask = UIViewAutoresizingFlexibleWidth
    @decodedField.text = ''
    @decodedField.textAlignment = NSTextAlignmentCenter
    @decodedField.textColor = UIColor.whiteColor
    @decodedField.font = UIFont.systemFontOfSize(32)
    @decodedField.backgroundColor = UIColor.colorWithWhite(0.1, alpha: 0.1)
    @decodedField.layer.cornerRadius = 5

    self.view.addSubview(@decodedField)

    # Perform custom UI setup here
    self.nextKeyboardButton = UIButton.buttonWithType(UIButtonTypeSystem)
    self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", "Title for 'Next Keyboard' button"), forState: UIControlStateNormal)
    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
    self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: UIControlEventTouchUpInside)
    nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint.constraintWithItem(self.nextKeyboardButton,
      attribute: NSLayoutAttributeLeft,
      relatedBy: NSLayoutRelationEqual,
      toItem: self.view, attribute: NSLayoutAttributeLeft,
      multiplier: 1.0, constant: 4.0)
    nextKeyboardButtonBottomConstraint = NSLayoutConstraint.constraintWithItem(self.nextKeyboardButton,
      attribute: NSLayoutAttributeBottom,
      relatedBy: NSLayoutRelationEqual,
      toItem:
      self.view, attribute: NSLayoutAttributeBottom,
      multiplier: 1.0, constant: -4.0)

    self.view.addSubview(self.nextKeyboardButton)
    self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint])

    @timer = nil
    @morse_code = ''
    @timer_threshold = 0.4
  end

  def didTapDot
    @morse_code << '.'
    label = @morse_code + ' => '
    if decoded = MORSE_CODE[@morse_code]
      label << decoded
    else
      label << '???'
    end
    @decodedField.text = label
    reset_timer
  end

  def didTapDash
    @morse_code << '-'
    label = @morse_code + ' => '
    if decoded = MORSE_CODE[@morse_code]
      label << decoded
    else
      label << '???'
    end
    @decodedField.text = label
    reset_timer
  end

  def didTapSpace
    if @timer
      @timer.fire
    end
    textDocumentProxy.insertText(' ')
  end

  def didTapDelete
    textDocumentProxy.deleteBackward
  end

  def reset_timer
    if @timer
      @timer.invalidate
    end

    @timer = NSTimer.scheduledTimerWithTimeInterval(@timer_threshold, target: self, selector: 'translate_morse_code', userInfo: nil, repeats: false)
  end

  def translate_morse_code
    if decoded = MORSE_CODE[@morse_code]
      textDocumentProxy.insertText(decoded)
    end
    @decodedField.text = ''
    @morse_code = ''
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
    self.nextKeyboardButton.setTitleColor(textColor, forState: UIControlStateNormal)
  end

end
