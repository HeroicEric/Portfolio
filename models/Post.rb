class Post
	include DataMapper::Resource
	
	property :id,         Serial
	property :title,      String
	property :slug,       String
	property :body,       Text
	property :created_at, DateTime
	property :updated_at, DateTime
	
	has n, :comments
	
	def url
		"/#{slug}"
	end

  def self.make_slug(title)
		title.downcase.gsub(/ /, '_').gsub(/[^a-z0-9_]/, '').squeeze('_')
	end

  def date
    day = created_at.day
    month = created_at.month
    year = created_at.year

    created_at.strftime(fmt='%b %d, %Y')
  end
end
