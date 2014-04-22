class Post
  attr_reader :author, :message, :profile_image_url
  attr_accessor :profile_image

  def initialize(dict)
    @author = dict['author']
    @message = dict['selftext']
    @profile_image_url = "http://www.mr-mojo-risin.net/wp-content/uploads/2010/11/icon_reddit_01.png" #dict['profile_image_url']
    @profile_image = nil
  end
end
