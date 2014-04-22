class RedditController < UITableViewController
  def viewDidLoad
    @posts = []
    searchBar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, self.tableView.frame.size.width, 0))
    searchBar.delegate = self;
    searchBar.showsCancelButton = true;
    searchBar.sizeToFit
    view.tableHeaderView = searchBar
    view.dataSource = view.delegate = self

    searchBar.text = 'xcode crash'
    searchBarSearchButtonClicked(searchBar)
  end

  def searchBarSearchButtonClicked(searchBar)
    query = searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    url = "http://www.reddit.com/search.json?q=#{query}"

    @posts.clear
    Dispatch::Queue.concurrent.async do 
      json = nil
      begin
        json = JSONParser.parse_from_url(url)
      rescue RuntimeError => e
        presentError e.message
      end

      new_posts = []
      json['results'].each do |dict|
        new_posts << Tweet.new(dict)
      end

      Dispatch::Queue.main.sync { load_posts(new_posts) }
    end

    searchBar.resignFirstResponder
  end

  def searchBarCancelButtonClicked(searchBar)
    searchBar.resignFirstResponder
  end

  def load_posts(posts)
    @posts = posts
    view.reloadData
  end
 
  def presentError(error)
    # TODO
    $stderr.puts error.description
  end
 
  def tableView(tableView, numberOfRowsInSection:section)
    @posts.size
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    TweetCell.heightForTweet(@posts[indexPath.row], tableView.frame.size.width)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    tweet = @posts[indexPath.row]
    TweetCell.cellForTweet(tweet, inTableView:tableView)
  end
  
  def reloadRowForTweet(tweet)
    row = @posts.index(tweet)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end
end
