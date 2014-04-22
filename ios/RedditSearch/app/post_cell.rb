class PostCell < UITableViewCell
  CellID = 'CellIdentifier'
  MessageFontSize = 14

  def self.cellForTweet(post, inTableView:tableView)
    cell = tableView.dequeueReusableCellWithIdentifier(PostCell::CellID) || PostCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)
    cell.fillWithTweet(post, inTableView:tableView)
    cell
  end
 
  def initWithStyle(style, reuseIdentifier:cellid)
    if super
      self.textLabel.numberOfLines = 0
      self.textLabel.font = UIFont.systemFontOfSize(MessageFontSize)
    end
    self
  end
 
  def fillWithTweet(post, inTableView:tableView)
    self.textLabel.text = post.message
    
    unless post.profile_image
      self.imageView.image = nil
      Dispatch::Queue.concurrent.async do
        profile_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(post.profile_image_url))
        if profile_image_data
          post.profile_image = UIImage.alloc.initWithData(profile_image_data)
          Dispatch::Queue.main.sync do
            self.imageView.image = post.profile_image
            tableView.delegate.reloadRowForTweet(post)
          end
        end
      end
    else
      self.imageView.image = post.profile_image
    end
  end

  def self.heightForTweet(post, width)
    constrain = CGSize.new(width - 57, 1000)
    size = post.message.sizeWithFont(UIFont.systemFontOfSize(MessageFontSize), constrainedToSize:constrain)
    [57, size.height + 8].max
  end

  def layoutSubviews
    super
    self.imageView.frame = CGRectMake(2, 2, 49, 49)
    label_size = self.frame.size
    self.textLabel.frame = CGRectMake(57, 0, label_size.width - 59, label_size.height)
  end
end
