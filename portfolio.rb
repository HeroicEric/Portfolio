require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'haml'
require 'digest/md5'

# Require Models
Dir.glob("#{Dir.pwd}/models/*.rb") { |m| require "#{m.chomp}" }

set :haml, { :format => :html5 } # default for Haml format is :xhtml

set :username, 'eric'
set :token, 'thisdoesntmatt3ry3t!'
set :password, 'swordfish'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/portfolio.db")

# Finalize/initialyize DB
DataMapper.finalize
DataMapper::auto_upgrade!

helpers do
  def admin? ; request.cookies[settings.username] == settings.token ; end
  def protected! ; halt [401, 'Not Authorized'] unless admin? ; end
end

get '/admin' do
  haml :admin
end

post '/login' do
  if params['username']==settings.username&&params['password']==settings.password
    response.set_cookie(settings.username,settings.token)
    redirect '/'
  else
    "AIN'T!!!!!"
  end
end

get '/' do
	@posts = Post.all
  @works = Work.last(3)

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
  protected!
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
get '/post/:slug' do
  @post = Post.first(:slug => params[:slug])
  puts @post
  @posts = Post.all
  haml :post
end

# Edit Post
get '/post/:slug/edit' do
	@post = Post.first(:slug => params[:slug])
	
	haml :post_edit
end

# Update Post
put '/post/:slug' do
  @post = Post.first(:slug => params[:slug])

  if @post.update(
      :title => params[:title],
      :slug => params[:slug],
      :body => params[:body]
    )
    status 201
    redirect '/post/' + @post.slug
  else
    status 400
    haml :post_edit
  end
end

# Adds a new comment
post '/comment' do
	@comment = Comment.new(params[:comment])
  @comment.md5 = Digest::MD5.hexdigest(@comment.email.downcase.strip)
	@post = Post.get(@comment.post_id)
	@post.comments << @comment

 	if @post.save
 		status 201 # Created successfully
 		redirect "/post/#{@post.slug}"
 	else
 		status 400 # Bad Request(
 		redirect '/blog'
 	end
end

