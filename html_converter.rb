class HTMLConverter

	def initialize(read_file)
		File.readlines(read_file).each do |line|
			ind = 0
			while ind < line.length
				case line[ind]
				when "'"
					print "<span class='ruby-string'>"
					print line[ind...(line[ind+1...-1].index("'")+ind+2)]
					print "</span>"
					ind += line[ind+1...-1].index("'")+2
				else
					print line[ind]
					ind += 1
				end
			end
		end
	end

	def html_string

	end
end

HTMLConverter.new('./server.rb')