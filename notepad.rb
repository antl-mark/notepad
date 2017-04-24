require_relative "post.rb"
require_relative "link.rb"
require_relative "memo.rb"
require_relative "task.rb"

puts "Hello, this is youre diary"
puts "What you wont to write?"

choices = Post.post_types
choice = -1
until choice >= 0 && choice <= choices.size
  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end
  choice = STDIN.gets.chomp.to_i
end