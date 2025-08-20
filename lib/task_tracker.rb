require 'json'
#TODO Delete Task
#TODO Properties of each task(hash instead of array). Id,descreption,status(done/todo,progress),created and update date.
#TODO List all Done/Undone tasks on their own
#TODO Make the tasks appear vertically instead of an array
class TaskTracker
  attr_accessor :tasks, :to_do

  def initialize(tasks = {},to_do = [])
    puts "          >Task Tracker v0.5<          "
    puts "\n"
    @tasks = tasks
    @to_do = to_do
    file?
    menu
  end

  def task_list(array) #TODO Make the tasks appear vertically instead of an array
    puts "Current Tasks:#{array}" if !array.empty? #TODO Convert Hash into an array first and only output the tasks
    puts "You don't have any tasks yet. Good Job!" if array.empty?
  end


  def file?
    if File.file?('lib/task_data.json')
      file = File.read('lib/task_data.json') #Read the current tasks if file exists
      @tasks = JSON.parse(file)
      @tasks.each {|k,v| @to_do << @tasks[k]["to_do"]}
    else
      File.open('lib/task_data.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Create an empty JSON if not
      end
    end
  end

  def menu
    puts "=============== M E N U ==============="
    # task_list(@tasks) #TODO See method
    puts "\n"
    puts "add - Add new Task (add Do the maid)"
    puts "2 - Delete Task"#Either by ID or string #TODO
    puts "3 - Update task" #TODO
    puts "showall - Show all tasks"
    puts "5 - Show all tasks marked as Done" #TODO
    puts "6 - Show all tasks marked as Undone" #TODO
    puts "exit - Close Task Tracker"
    puts "======================================="
    puts "\n"

    print "Choose your action:"
    action = gets.downcase.split
    case action[0]
      when "add" then add_task(action.drop(1).join(" "))
      when "delete" then puts "Coming Soon!"
      when "update" then puts "Coming Soon!"
      when "showall" then puts show_all
      when "done" then puts "Coming Soon!"
      when "list" then puts "Coming Soon!"
      when "todo" then puts "Coming Soon!"
      when "exit" then exit
      else puts "Invalid Option"
    end
    menu
  end

  def add_task(task)
    task_id = @to_do.length + 1
    @tasks[task_id] = {}

    @tasks[task_id][:to_do] = task
    @tasks[task_id][:id] = @to_do.length + 1
    @tasks[task_id][:progress] = "0%"
    @tasks[task_id][:status] = "to_do"
    @tasks[task_id][:created_at] = Time.now
    @tasks[task_id][:updated_at] = Time.now


    @to_do << task
    update_list
  end

  def show_all #TODO Make it look better
    print @to_do
  end

  def update_list
    File.open('lib/task_data.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Update the file
    end
  end

  def delete_task(task)
    #TODO Read through the file and make it into an array
    #TODO Warn if the task list is emptys
    #TODO Either make the user write the actual task or number them.
    #TODO Remove the task from the array and update the file
  end

  def update_task

  end

  def clear_list
    #TODO Warn first
  end

end
