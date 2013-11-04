class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = MainController.alloc.init
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end

class MainController < UIViewController
  def viewDidLoad
    #creating a button and setting its title
    @button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @button.setTitle('Send Email', forState:UIControlStateNormal)
    
    #connects the presentEmailEditor method to the button-press action
    @button.addTarget(self, action:'presentEmailEditor', forControlEvents:UIControlEventTouchUpInside)
    
    #specifies the button location on the view
    margin = 20
    @button.frame = [[margin, 260], [view.frame.size.width - margin * 2, 40]]
    
    #binds the button to the view
    view.addSubview(@button)
  end
  
  def presentEmailEditor
    # called when the button is pressed
    
    # http://stackoverflow.com/a/1513433/94154
    #
    # MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    # controller.mailComposeDelegate = self;
    # [controller setSubject:@"My Subject"];
    # [controller setMessageBody:@"Hello there." isHTML:NO]; 
    # if (controller) [self presentModalViewController:controller animated:YES];
    # [controller release];
    
    controller = MFMailComposeViewController.alloc.init
    controller.mailComposeDelegate = self
    controller.setSubject("My Subject")
    controller.setMessageBody("Hello there", isHTML:false)
    self.presentModalViewController(controller, animated:true)
  end
  
  #- (void)mailComposeController:(MFMailComposeViewController*)controller  
  #          didFinishWithResult:(MFMailComposeResult)result 
  #                        error:(NSError*)error;
  #{
  #  if (result == MFMailComposeResultSent) {
  #    NSLog(@"It's away!");
  #  }
  #  [self dismissModalViewControllerAnimated:YES];
  #}
  def mailComposeController(controller, didFinishWithResult:result, error:error)
    if result == MFMailComposeResultSent
      puts "It's away!"
    end
    self.dismissModalViewControllerAnimated(true)
  end
end
