class Link < Post

  def initialize
    super
    @url = ""
  end

  def read_from_console
    puts "Write the URL."
    @url = STDIN.gets.chomp

    puts "What is this URL?"
    @text = STDIN.gets.chomp
  end

  def to_strings
    time_string = "Writed: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")}\n\r \n\r"
    [@url, @text, time_string]
  end

end