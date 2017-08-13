require "./keywords.rb"

class HTMLConverter

  def initialize(read_file, write_file)
    @write_file = open(write_file, 'w')
    @write_file.write("<p class='code-snippet'>")
    rbkeys = RubyKeywords.new
    File.readlines(read_file).each do |line|
      ind = white_space(line, 0)
      while ind < line.length
        if line[ind..-1].start_with?("def ")
          ind = function_to_html(line, ind)
        elsif line[ind..-1].start_with?("class ")
          ind = function_to_html(line, ind, "class ")
        end
        if line[ind] && line[ind] == line[ind].upcase && /[[:alpha:]]/.match(line[ind])
          ind = module_to_html(line, ind)
        end
        ind = ruby_keyword(rbkeys, line, ind)
        case line[ind]
        when "'"
          ind = html_string(line, ind)
        when '"'
          ind = html_string(line, ind, '"')
        when "/"
          ind = html_string(line, ind, "/")
        else
          @write_file.write(line[ind])
          ind += 1
        end
      end
      @write_file.write("<br>")
    end
    @write_file.write("</p>")
  end

  def function_to_html(line, ind, declaration = "def ")
    @write_file.write("<span class='ruby-keyword'>")
    @write_file.write(declaration)
    @write_file.write("</span>")
    ind += declaration.length
    @write_file.write("<span class='ruby-function'>")
    while line[ind] != "(" && ind < line.length
      @write_file.write(line[ind])
      ind += 1
    end
    @write_file.write("</span>")
    if ind < line.length
      @write_file.write("(<span class='ruby-argument'>")
      ind += 1
      until line[ind] == ")"
        if line[ind] == ","
          @write_file.write("</span>, <span class='ruby-argument'>")
          ind += 2
        else
          @write_file.write(line[ind])
          ind += 1
        end
      end
      @write_file.write("</span>")
    end
    ind
  end

  def module_to_html(line, ind)
    @write_file.write("<span class='ruby-module'>")
    until [".", "["].include?line[ind]
      @write_file.write(line[ind])
      ind += 1
    end
    @write_file.write("</span>")
    ind
  end

  def white_space(line, ind)
    while line[ind..-1].start_with?("  ") || line[ind..-1].start_with?("  ")
      @write_file.write("&nbsp;&nbsp;")
      if line[ind..-1].start_with?("  ")
        ind += 2
      else
        ind += 1
      end
    end
    ind
  end

  def html_string(line, ind, delim = "'")
    @write_file.write("<span class='ruby-string'>")
    @write_file.write(line[ind..(line[ind+1..-1].index(delim)+ind+1)])
    @write_file.write("</span>")
    ind += line[ind+1..-1].index(delim)+2
  end

  def ruby_keyword(rbkeys, line, ind)
    rbkeys.keywords.each do |kw|
      if line[ind..-1].start_with?(kw) && !(/[[:alpha:]]/.match(line[ind-1]))
        @write_file.write("<span class='ruby-keyword'>")
        @write_file.write(kw)
        @write_file.write("</span>")
        ind += kw.length
        break
      end
    end
    ind
  end
end

HTMLConverter.new(ARGV[0], ARGV[1])

