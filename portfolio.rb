require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'haml'
require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'
require 'dm-timestamps'
require 'sinatra/logger'
	
# Require Models
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }

# Set DM logger location and level
DataMapper::Logger.new("log/dm.log", :debug)

set :haml, :format => :html5 # default for Haml format is :xhtml

configure :development do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.sqlite3")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/production.sqlite3")
end

# Finalize/initialize DB
DataMapper.finalize
DataMapper::auto_upgrade!

get '/' do
	@posts = Post.all
  @work = Work.last

  haml :home
end

get '/blog' do
	@posts = Post.all
	haml :blog
end

get '/work' do
  @works = Work.all
  haml :work
end

get '/work/new' do
  @work = Work.new
  haml :work_new
end

post '/work' do
  @work = Work.create(params[:work])

  if @work.save
		status 201 # Created successfully
		redirect '/work/' + @work.slug
	else
		status 400 # Bad Request(
		haml :work_new
	end
end

get '/work/:slug' do
  @work = Work.first(:slug => params[:slug])
  haml :work_details
end

get '/work/:slug/edit' do
  @work = Work.first(:slug => params[:slug])
  haml :work_edit
end

# Update Work
put '/work/:slug' do
  @work = Work.first(:slug => params[:slug])

  if @work.update(params[:work])
    status 201
    redirect '/work/' + @work.slug
  else
    status 400
    haml :work_edit
  end
end

# Add a new Post
get '/post/new' do
	@post = Post.new
	
	haml :post_new
end

# Creat a new Post
post '/post' do
	@post = Post.create(
    :title => params[:title],
    :slug => Post.make_slug(params[:title]),
    :body => params[:body]
  )

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
	@comments = @post.comments.all(:order => [:created_at.desc])
	
	haml :post
end

# Edit Post
get '/post/:id/edit' do
	@post = Post.get(params[:id])
	
	haml :post_edit
end

# Update Post
put '/post' do

end

# Adds a new comment
post '/comment' do
	@comment = Comment.new(params[:comment])
	@post = Post.get(@comment.post_id)
	
	@post.comments << @comment

	puts @comment.author	
	puts @post.title
	
 	if @post.save
 		status 201 # Created successfully
 		redirect "/post/#{@post.id}"
 	else
 		status 400 # Bad Request(
 		redirect '/blog'
 	end
end
