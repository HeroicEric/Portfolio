require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'haml'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/portfolio.db")

	
# Require Models
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }

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
end

class Comment
	include DataMapper::Resource
	
	property :id,         Serial
	property :author,     String
	property :email,      String
	property :url,        String
	property :body,       String
	property :post_id,    String
	property :created_at, DateTime
	
	belongs_to :post
end

class Work
	include DataMapper::Resource
	
	property :id,          Serial
	property :title,       Text
	property :client,      String
	property :description, Text
	property :tech_used,   Text
	property :thumb,       Integer
	property :created_at,  DateTime
	property :updated_at,  DateTime
	
	has n, :screenshots
end

class Screenshot
	include DataMapper::Resource
	
	property :id,          Serial
	property :alt,         String
	property :title,       String
	property :url_small,   String
	property :url_medium,  String
	property :url_large,   String
	
	belongs_to :work
end

get '/blog' do
	@posts = Post.all
	
	haml :blog
end

# Add a new Post
get '/post/new' do
	@post = Post.new
	
	haml :post_new
end

# Creat a new Post
post '/post' do
	@post = Post.create(params[:post])
	
	if @post.save
		status 201 # Created successfully
		redirect '/blog'
	else
		status 400 # Bad Request(
		haml :post_new
	end
	
end

# View a Post
get '/post/:id' do
	@post = Post.get(params[:id])
	
	haml :post
end

get '/post/edit/:id' do
	@post = Post.get(params[:id])
end

post '/comment' do
	@post = Post.get(params[:post_id])

	@comment = @post.comments.new(params[:comment])
	
	puts @post.title
	
 	if @post.save
 		status 201 # Created successfully
 		redirect "/post/#{@post.id}"
 	else
 		status 400 # Bad Request(
 		redirect '/blog'
 	end
end

get '/work' do
	@work = Work.new(:title => "Fake it Till you Make It", :client => "Quinnipiac University", :description => "This is a fake description for a fake piece of work.", :tech_used => "HTML/CSS, jQuery, Sinatra", :thumb => 0)
	
	@screenshot = Screenshot.new(:alt => "Test Alternate Text", :title => "This is an Example Title", :url_small => "http://youfounderic.com/misc/portfolio/img/thumb1.jpg", :url_medium => "http://youfounderic.com/misc/portfolio/img/medium1.jpg", :url_large => "http://youfounderic.com/misc/portfolio/img/large1.png")
	
	@work.screenshots << @screenshot
	
	@work.save
	@screenshot.save
	
	@works = Work.all
	
	haml :work
end

get '/work/new' do
	@work = Work.new

	haml :work_new
end

get '/work/:id' do
	@work = Work.get(params[:id])
	
	@work = Work.new(:title => "Fake it Till you Make It", :client => "Quinnipiac University", :description => "This is a fake description for a fake piece of work.", :tech_used => "HTML/CSS, jQuery, Sinatra", :thumb => 0)
	
	@screenshot = Screenshot.new(:alt => "Test Alternate Text", :title => "This is an Example Title", :url_small => "http://youfounderic.com/misc/portfolio/img/thumb1.jpg", :url_medium => "http://youfounderic.com/misc/portfolio/img/medium1.jpg", :url_large => "http://youfounderic.com/misc/portfolio/img/large1.png")
	
	@work.screenshots << @screenshot
	
	@work.save
	@screenshot.save
	
	@works = Work.all
	
	haml :work_details
end

# Finalize/initialize DB
DataMapper.finalize
DataMapper::auto_upgrade!
