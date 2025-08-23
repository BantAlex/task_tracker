require 'json'
#TODO Issues arise when you have tasks with the same description - It will delete the first one
#TODO List all Done/Undone tasks on their own
#TODO Tasks can somehow have the same ID (maybe)
#TODO Make the tasks appear vertically instead of an array
#TODO Take care of the file?, update_file and read_file trio.
#TODO README
class TaskTracker
  attr_accessor :tasks, :to_do

  def initialize
    puts "          >Task Tracker v0.5<          "
    @tasks = []
    @to_do = []

    file?
    update_file
    menu
  end

  def read_file
    file = File.read('lib/task_data.json')
    @tasks = JSON.parse(file)
    @tasks.each {|task| @to_do << task["to_do"]}
    @to_do = @to_do.uniq
  end

  def file?
    if File.file?('lib/task_data.json') #Read the current tasks if file exists
      read_file
    else
      File.open('lib/task_data.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Create an empty JSON if not
      end
    end
  end

  def menu
    update_file
    puts "=============== M E N U ==============="
    puts "add [task] - Add new Task"
    puts "delete id [id] - Delete a Task via ID"
    puts "delete [task] - Delete a Task via description"
    puts "3 - Update task" #TODO
    puts "clearlist - To reset your Tasks"
    puts "showall - Show all tasks"
    puts "5 - Show all tasks marked as Done" #TODO
    puts "6 - Show all tasks marked as Undone" #TODO
    puts "exit - Close Task Tracker"
    puts "======================================="

    print "Choose your action:"
    action = gets.split
    case action[0].downcase
      when "add" then add_task(action.drop(1).join(" "))

      when "delete"
        if action[1]
          if action[1].downcase == "id"
            delete_task(nil,action.drop(2).join(" "))
          else
            delete_task(action.drop(1).join(" "),nil)
          end
        end

      when "clearlist" then clear_list
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
    @to_do << task

    new_task = {
        to_do: task.downcase,
        id: @to_do.length,
        progress: "0%",
        status: "to_do",
        created_at: Time.now,
        updated_at: Time.now
    }

    @tasks << new_task
    update_file
    show_all
  end

   def delete_task(via_task,via_id)

    if via_task
      puts "There are no such tasks in the To Do list." if !@to_do.include?(via_task)
      @tasks.each_with_index do |task,index|
        @tasks.delete_at(index) if task["to_do"] == via_task
      end
      @to_do.each_with_index{|task,index| @to_do.delete_at(index) if task == via_task}
    end

    if via_id
      @tasks.each_with_index do |task,index|
        if task["id"].to_i == via_id.to_i
          @tasks.delete_at(index)
          @to_do = [] #Reset the to_do array to input the new info
          @tasks.each {|task| @to_do << task["to_do"]} #Input the new info in
        end
      end
      # puts "There is no such ID in the To Do list."
    end

    update_file
    show_all
   end

  def show_all #TODO Make it look better
    print @to_do
    puts "\n"
  end

  def update_file #^No Idea why this works
    File.open('lib/task_data.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Update the file
    end
    read_file #^No Idea why this works
  end



  def update_task

  end

  def clear_list
    puts "Are you sure?(y/n)"
    terminate = gets.chomp.downcase

    if terminate == "y"
      @tasks = []
      @to_do = []
      update_file
      menu
    elsif terminate == "n"
      menu
    else
      puts "Not a Valid Option"
    end
  end

end
