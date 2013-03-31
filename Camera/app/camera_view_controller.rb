class CameraViewController < UIViewController
  INVALID_LABEL_WIDTH   = 260
  INVALID_LABEL_HEIGHT  = 40
  INVALID_LABEL_POS_X   = (UIScreen.mainScreen.bounds.size.width - INVALID_LABEL_WIDTH) / 2
  INVALID_LABEL_POS_Y   = (UIScreen.mainScreen.bounds.size.height - INVALID_LABEL_HEIGHT) / 2

  FIRE_BUTTON_MARGIN = 5
  FIRE_BUTTON_WIDTH = 320
  FIRE_BUTTON_HEIGHT = 44
  FIRE_BUTTON_POS_X   = 0
  FIRE_BUTTON_POS_Y   = UIScreen.mainScreen.bounds.size.height - FIRE_BUTTON_HEIGHT - FIRE_BUTTON_MARGIN

  def viewDidLoad
    self.view.backgroundColor = UIColor.blackColor
  end

  def viewDidAppear(animated)
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
      @ipc = UIImagePickerController.alloc.init
      @ipc.delegate = self
      @ipc.sourceType = UIImagePickerControllerSourceTypeCamera
      @ipc.allowsEditing = false
      @ipc.showsCameraControls = false
      @ipc.view.addSubview(fire_button)
      self.presentModalViewController(@ipc, animated: true)
    else
      make_invalid_screen
    end
  end

  def make_invalid_screen
    invalid_label = UILabel.new.tap do |label|
      label.text = 'The device can not use camera'
      label.textColor = UIColor.whiteColor
      label.backgroundColor = UIColor.blackColor
      label.frame = [[INVALID_LABEL_POS_X, INVALID_LABEL_POS_Y],
                     [INVALID_LABEL_WIDTH, INVALID_LABEL_HEIGHT]]
    end
    self.view.addSubview(invalid_label)
  end

  def fire_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle("Take picture", forState: UIControlStateNormal)
    button.frame = [[FIRE_BUTTON_POS_X, FIRE_BUTTON_POS_Y],
                    [FIRE_BUTTON_WIDTH, FIRE_BUTTON_HEIGHT]]
    button.addTarget(self, action:'take_picture', forControlEvents:UIControlEventTouchUpInside)
  end

  def take_picture
    @ipc.takePicture
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)
    imageToSave = info.objectForKey UIImagePickerControllerOriginalImage
    UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
  end
end
