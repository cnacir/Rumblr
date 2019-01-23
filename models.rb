require 'sinatra/activerecord'
require 'pg'

set :database, {adapter:'postgresql', database: 'rumblr', host: 'localhost', username: 'postgres', password: 'Canmert&91'}

class User < ActiveRecord::Base
	has_many :posts, :dependent => :destroy
end

class Post < ActiveRecord::Base
	belongs_to :user
end
