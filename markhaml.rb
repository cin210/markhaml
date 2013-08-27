#!usr/bin/env ruby
require 'octokit.rb'
require 'html2haml'

#  IF YOU DONT PASS AN OAUTH TOKEN YOU CAN ONLY PARSE 60 DOCS PER DAY, YOU TURKEY
#  https://github.com/settings/tokens/new
#  GET ONE, THEN UNCOMMENT THIS:

#  TOKEN = "PUTYOURPERSONALACCESSTOKENFROMGITHUBHERE"

class MarkHaml
  
  def parse(dir)
    return if dir == "." || dir == '..'
    where_i_came_from = Dir.pwd
    
    if File.file?(dir) && dir[-4,4] == 'html'
      html_to_haml dir
    end
    
    if File.file?(dir) && dir[-2,2] == 'md'
      md_to_html dir
    end
  
    if File.directory? dir
      Dir.chdir dir
      puts "#{Dir.pwd}"
      Dir.foreach(dir) do |child|
        next if child == "." || child == '..' || child[0,1] == "."
        path_to_child = File.join(dir, child)
        puts "#{path_to_child}"
        parse(path_to_child)
      end
      puts "Returning to #{dir}"
      Dir.chdir where_i_came_from
    end
  
  end

  def md_to_html(dir)
    filename = dir
    new_filename = dir.chomp(".md")
    new_filename = new_filename + ".html"
  
    puts "  Converting\n  #{dir} =>\n  #{new_filename}"
    new_file = File.new new_filename, "w+"
    new_file.puts @octo.markdown(File.read(filename))
  
    new_file.close
    @markdown_conversions += 1
    new_filename
  rescue
    puts "!  Failed to convert #{dir} to HTML"
  end

  def html_to_haml(dir)
    filename = dir
    new_filename = dir.chomp(".html")
    new_filename = new_filename + ".haml"

    puts "  Converting\n  #{dir} =>\n  #{new_filename}"
    new_file = File.new new_filename, "w+"
    new_file.puts Haml::HTML.new(File.read(filename)).render
  
    new_file.close
    self.haml_conversions += 1
    new_file
  rescue
    puts "!  Failed to convert #{dir} to HAML"
  end

  def initialize(dir)
    return unless dir && File.directory?(dir)
    
    @markdown_conversions = 0
    @haml_conversions     = 0 
    @directory            = dir
    
    puts star_squiggle 15
    puts "*~LET'S CONVERT SOME MARKDOWN~*\n" * 5
    puts star_squiggle 15 
    puts "!!!ALERT!!!\nCONVERTING something.md => something.html or something.html => something.haml \n_WILL_ OVERWRITE EXISTING FILES \nLOL TOO LATE NOW THO" 
    puts "PARSING DIRECTORY #{@directory}\n\n" 
    
    # get a token if you have > 50 files to convert to html so your IP doesn't get shut out
    if defined?(TOKEN)
      @octo = Octokit::Client.new :access_token => TOKEN
    else
      @octo = Octokit
    end
    
    parse @directory
  
    puts star_squiggle 15
    puts "Finished."
    puts "Converted #{@markdown_conversions} files to HTML."
    puts "Converted #{@haml_conversions } files to HAML."
    puts " Now would be a good time to type 'git status' if you're into that sort of thing"
  end

  def star_squiggle(n=1)
    "#{'*~' * n}*"
  end
  
end

  
MarkHaml.new(ARGV[0])
