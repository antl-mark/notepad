require_relative "post.rb"
require_relative "link.rb"
require_relative "memo.rb"
require_relative "task.rb"

# id, limit, type - parametru po yakum vuvodumo dani z db

require 'optparse'

#All our options will be saved in here
options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read_from_db.rb [options]'

  opt.on('-h', 'Prints this help') do
    puts opt
    exit
  end

  opt.on('--type POST_TYPE','Which type notes show? (Default - any)') { |o| options[:type] = o}
  opt.on('--id POST_ID','Shows the notes corresponding id') { |o| options[:id] = o}
  opt.on('--limit NUMBER','How many notes show last? (Default - all)') { |o| options[:limit] = o}

end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

if result.is_a? Post

  puts "Note - #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each do |line|
    puts line
  end

else #table of results

  print "| id\t| @type\t| @created_at\t\t\t| @text\t\t\t| @url\t\t| @due_date\t|"

  result.each do |row|
    puts
    row.each do |elem|
      print "| #{elem.to_s.delete("\n\r")[0..40]}\t"
    end
  end
end

puts

