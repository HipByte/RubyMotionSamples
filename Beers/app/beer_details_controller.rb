class BeerDetailsController < UIViewController
  def loadView
    self.view = UIWebView.alloc.init
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
  end

  def show_details_for_beer(beer)
    navigationItem.title = beer.title
    request = NSURLRequest.requestWithURL(beer.url)
    view.loadRequest(request)
  end 
end
