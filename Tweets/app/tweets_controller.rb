class TweetsController < UITableViewController
  def viewDidLoad
    @tweets = []
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
    url = "http://search.twitter.com/search.json?q=#{query}"

    @tweets.clear
    Dispatch::Queue.concurrent.async do 
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:error_ptr)
      unless data
        present_error error_ptr[0]
        return
      end
      json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
      unless json
        present_error error_ptr[0]
        return
      end

      new_tweets = []
      json['results'].each do |dict|
        new_tweets << Tweet.new(dict)
      end

      Dispatch::Queue.main.sync { load_tweets(new_tweets) }
    end

    searchBar.resignFirstResponder
  end

  def searchBarCancelButtonClicked(searchBar)
    searchBar.resignFirstResponder
  end

  def load_tweets(tweets)
    @tweets = tweets
    view.reloadData
  end
 
  def present_error(error)
    # TODO
    $stderr.puts error.description
  end
 
  def tableView(tableView, numberOfRowsInSection:section)
    @tweets.size
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    TweetCell.height_for_tweet(@tweets[indexPath.row], tableView.frame.size.width)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    tweet = @tweets[indexPath.row]
    TweetCell.cell_for_tweet(tweet, inTableView:tableView)
  end
  
  def reload_row_for_tweet(tweet)
    row = @tweets.index(tweet)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end
end
