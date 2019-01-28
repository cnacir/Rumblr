require 'sinatra/activerecord'
require 'pg'
require 'sinatra/base'

configure :development do
  set :database, {
    adapter: "postgresql",
    database: "rumblr",
		host: "localhost",
    username: "postgres",
    password: ENV["PSQL_PASSWORD"]
  }
end

configure :production do
    set :database, ENV['DATABASE_URL']
end

class User < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
	self.per_page = 5
end

class Post < ActiveRecord::Base
	belongs_to :user
	self.per_page = 5
end
