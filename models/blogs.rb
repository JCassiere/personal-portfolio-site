require 'io/console'

class Blog
	attr_reader :posts

	def initialize(blog_dir)
		@posts = []
		blogs = (Dir.entries(blog_dir).sort_by {|file| File.mtime(blog_dir + file)}).reverse
		blogs.each do |file|
		  unless (file == '.' or file == '..')
		  	@posts << IO.read(blog_dir + file)
			end
		end
	end
end