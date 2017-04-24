require "date"
class Task < Post

  def initialize
    @due_date = nil
  end

  def read_from_console
    puts "What the task?"
    @text = STDIN.gets.chomp
    puts "What is deadline? Write the date in format - DD.MM.YYYY"
    input = STDIN.gets.chomp
    @due_date = Date.parse(input)
  end

  def to_strings
    time_string = "Writed: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")}\n\r \n\r"
    deadline = "Deadline: #{@due_date}"
    [deadline, @text, time_string]
  end

end