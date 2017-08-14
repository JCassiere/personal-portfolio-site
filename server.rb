require 'sinatra'
require './models/blogs.rb'

blog_dir = './public/blog_posts/'

get '/' do
	@blogs = Blog.new(blog_dir)
	erb :index
end