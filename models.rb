require 'sinatra/activerecord'
require 'pg'
require 'sinatra/base'

set :database, {adapter:'postgresql', database: 'rumblr', host: 'localhost', username: 'postgres', password: ENV["POSTGRESQL_PASSWORD"]}

class User < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
	self.per_page = 5
end

class Post < ActiveRecord::Base
	belongs_to :user
	self.per_page = 5
end
