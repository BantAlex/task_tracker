require 'json'

class TaskTracker
  attr_accessor :tasks

  def initialize(tasks = [])
    @tasks = tasks
    file?
    add_task
    initialize(@tasks)
  end

  def cli_print(array)
    puts "====================="
    puts "Current Tasks:#{array}" if !array.nil?  #TODO
    puts "You don't have any tasks yet. Good Job!" if array.nil? #TODO
    puts "====================="
  end


  def file?
    if File.file?('lib/task.json')
      file = File.read('lib/task.json') #Read the current tasks if file exists
      @tasks = JSON.parse(file)
      cli_print(@tasks)
    else
      File.open('lib/task.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Create an empty JSON if not
      end
    end
  end

  def add_task
    puts "What task would you like to do later?"
    input = gets.chomp
    @tasks << input

    File.open('lib/task.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Update the file
    end
  end
end

ta= TaskTracker.new
