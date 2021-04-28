class DetailController < UIViewController
  def loadView
    self.view = UIScrollView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight
    view.autoresizesSubviews = true
    view.backgroundColor = UIColor.whiteColor

    @text_label = UILabel.alloc.init
    @text_label.numberOfLines = 0
    view.addSubview(@text_label)
  end

  def viewDidLoad
    navigationItem.title = "Sample Text"
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCompose, target: self, action: :display_font)
  end

  def viewWillAppear(animated)
    font = UIFont.fontWithName(@font_name, size:16)
    frame_size = sample_text.sizeWithFont(font, constrainedToSize:[self.view.bounds.size.width - 20, 1000], lineBreakMode:UILineBreakModeWordWrap)
    rect = [[10, 10], [frame_size.width, frame_size.height]]
    
    @text_label.text = sample_text
    @text_label.frame = rect
    @text_label.font = font

    view.contentSize = [self.view.frame.size.width, frame_size.height + 20]
  end

  def selected_font(font_name)
    @font_name = font_name
  end

  def sample_text
    <<EOS
    #{@font_name}
    
    RubyMotion offers developers the expressiveness of Ruby with no compromises. It's hard to imagine a more appealing way to build native iOS applications. 
    
    This is AWESOME! With just minimal iOS experience, I was able to get a working app up and running on my phone. Oh, the feeling of power!

    RubyMotion is a dream come true for Rubyists who want to create fast, native iOS apps!

    Now you can develop in your favorite language on your favorite mobile platform. Done right. For real. What are you waiting for?

    With RubyMotion, we can now leverage our Ruby expertise to solve problems in the mobile space. Developing for iOS will never be the same again.

    After years of iOS work, RubyMotion seems like a thousand kittens playing the piano while sliding down a double-rainbow.
EOS
  end

  def display_font
    @dynamic_controller ||= DynamicController.alloc.init
    @dynamic_controller.selected_font(@font_name)
    self.navigationController.pushViewController(@dynamic_controller, animated:true)
  end
end
