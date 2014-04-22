class TweetCell < UITableViewCell
  CellID = 'CellIdentifier'
  MessageFontSize = 14

  def self.cellForTweet(tweet, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(TweetCell::CellID) || TweetCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.fillWithTweet(tweet, inTableView:tableView)
    cell
  end
 
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end
 
  def fillWithTweet(tweet, inTableView:tableView)
    self.textLabel.text = tweet.message
    
    unless tweet.profile_image
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        profile_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(tweet.profile_image_url))
        if profile_image_data
          tweet.profile_image = UIImage.alloc.initWithData(profile_image_data)
          Dispatch::Queue.main.sync do
            self.imageView.image = tweet.profile_image
            tableView.delegate.reloadRowForTweet(tweet)
          end
        end
      end
    else
      self.imageView.image = tweet.profile_image
    end
  end

  def self.heightForTweet(tweet, width)
    constrain = CGSize.new(width - 57, 1000)
    size = tweet.message.sizeWithFont(UIFont.systemFontOfSize(MessageFontSize), constrainedToSize:constrain)
    [57, size.height + 8].max
  end

  def layoutSubviews
    super
    self.imageView.frame = CGRectMake(2, 2, 49, 49)
    label_size = self.frame.size
    self.textLabel.frame = CGRectMake(57, 0, label_size.width - 59, label_size.height)
  end
end
