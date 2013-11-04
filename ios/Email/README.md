# Email example

An example of how to send email from within a RubyMotion app

The code contains a basic translation of Objective-C code from http://stackoverflow.com/a/1513433/94154.

Synopsis:

From a `UIViewController`:

```ruby
def presentEmailEditor
  controller = MFMailComposeViewController.alloc.init
  controller.mailComposeDelegate = self
  controller.setSubject("My Subject")
  controller.setMessageBody("Hello there", isHTML:false)
  self.presentModalViewController(controller, animated:true)
end

def mailComposeController(controller, didFinishWithResult:result, error:error)
  if result == MFMailComposeResultSent
    puts "It's away!"
  end
  self.dismissModalViewControllerAnimated(true)
end
```