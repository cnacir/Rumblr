require 'sinatra'
require 'will_paginate'
require 'will_paginate/active_record'
require 'will_paginate-bootstrap'
require './models'

enable :sessions

get "/" do
	erb :landing_page
end


get "/login" do
	erb :login
end

post "/login" do
	user = User.find_by(username: params[:username])

	if user && user.password == params[:password]
		session[:user_id] = user.id
		redirect "/profile"

	else
		redirect "/login"
	end
end

get "/profile" do
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	else
		redirect "/"
	end

	@recent_posts = @current_user.posts.order(:created_at => :desc).page(params[:page])

	@bday = @current_user.birthday.strftime("%m/%d/%Y")
	@posts = @current_user.posts


	erb :profile
end

delete "/account" do
	@user = User.find(session[:user_id])
	@user.destroy unless @user.username == "admin"

	session[:user_id] = nil

	redirect "/"
end

delete "/post/:id" do
	@post = Post.find(params[:id])
	@post.destroy


	redirect "/profile"
end


post "/signup" do
	@user = User.create(
		username: params[:username],
		password: params[:password],
		birthday: params[:birthday],
		email: params[:email]
	)

	session[:user_id] = @user.id

	@current_user = User.find(session[:user_id])
	@recent_posts = @current_user.posts.order(:created_at => :desc).page(params[:page])
	@bday = @current_user.birthday.strftime("%m/%d/%Y")
	@posts = @current_user.posts

	redirect "/profile"
end

get "/users/:id" do
	@user = User.find(params[:id])
	@recent_posts = @user.posts.order(:created_at => :desc).page(params[:page])

	erb :user_id
end

get "/users" do
	if session[:user_id]
		@user = User.find(session[:user_id])
	else
		redirect "/"
	end

	@recent_posts = Post.all.order(:created_at => :desc).page(params[:page])

 	erb :users
end

post "/users" do
	@user = User.find_by(username: params[:search])
	if @user.username == params[:search]
		redirect "/users/" + @user.id.to_s
	else
		redirect "/users"
	end
end

get "/new_posts" do
	erb :new_posts
end


post "/new_posts" do
	@current_user = User.find(session[:user_id])
  Post.create(
    title: params[:title],
    content: params[:content],
    user_id: @current_user.id
  )

  redirect "/new_posts"
end


get "/logout" do
	session[:user_id] = nil


	redirect "/"
end
