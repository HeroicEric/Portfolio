class Comment
	include DataMapper::Resource
	
	property :id,         Serial
	property :author,     String
	property :email,      String
	property :url,        String
	property :body,       String
  property :md5,        String
 	property :post_id,    Integer # Not necessary, DM auto makes it!
	property :created_at, DateTime
	
	belongs_to :post

  def grav_image
    "http://gravatar.com/avatar/#{md5}"
  end
end
