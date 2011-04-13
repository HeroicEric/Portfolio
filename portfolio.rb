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

# Finalize/initialize DB
DataMapper.finalize
DataMapper::auto_upgrade!
