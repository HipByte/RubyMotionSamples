class Post
  attr_reader :author, :message, :profile_image_url
  attr_accessor :profile_image

  def initialize(dict)
    @author = dict['author']
    @message = dict['title']
    @profile_image_url = dict['thumbnail'] 
    @profile_image = nil
  end
end
