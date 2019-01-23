require 'sinatra'
require './models'
require 'sinatra/flash'

enable :sessions



get "/" do
	def current_user
		if session[:user_id]
			return User.find(session[:user_id])
		end
	end

	@current_user = current_user
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
		flash[:success] = "Welcome back!"

	else
		flash[:error] = "That username and/or password is incorrect."
		redirect "/login"
	end
end
get "/profile" do
	erb :profile
end
post "/signup" do
	user = User.create(
		username: params[:username],
		password: params[:password],
		birthday: Date.parse(params[:date_of_birth].to_s),
		email: params[:email]
	)

	session[:user_id] = user.id

	redirect "/profile"
end

get "/posts" do
  erb :posts
end

get "/new_posts" do
	erb :new_post
end

post "/new_posts" do
  Post.create(
    title: params[:title],
    content: params[:content],
    user_id: current_user.id
  )

  redirect "/new_posts"
end
#   output = ''
#   output += erb :new_posts
#   output += erb :posts, locals: { posts: Post.order(:created_at).all }
#   output
# end



get "/signout" do
	session[:user_id] = nil
	flash[:info] = "You have been signed out."

	redirect "/"
end
