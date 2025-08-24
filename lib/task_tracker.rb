require 'json'
#TODO Update task
#TODO Issues arise when you have tasks with the same description - It will delete the first one
#TODO List all Done/Undone tasks on their own
#TODO Tasks can somehow have the same ID if you delete and add one.(because it counts how many there are)
#TODO Make the tasks appear vertically instead of an array
#TODO Take care of the file?, update_file and read_file trio.
#TODO Try removing @to_do its kinda of reduntand. Only use-case is that you won't have to loop over the hash.
#TODO Make the tasks appear as typed maybe?
#TODO Status option needs improvemenent
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
    puts "update - Update a Task"
    puts "showall - Show all tasks"
    puts "done - Show all tasks marked as Done"
    puts "todo - Show all tasks marked as Undone"
    puts "clearlist - To reset your Tasks"
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

      when "update" then update_task
      when "showall" then show_all
      when "done" then show_done
      when "todo" then show_undone
      when "clearlist" then clear_list
      when "exit" then exit
      else puts "Invalid Option"
    end
    menu
  end

  def add_task(task)
    @to_do << task

    new_task = {
        to_do: task.downcase,
        id: @to_do.length, #^Maybe make it have the length of the last element's ID + 1?
        status: "to do",
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
    @tasks.each {|task| puts "#{task["id"]} - #{task["to_do"]} - #{task["status"]}"}
  end

  def update_file #^No Idea why this works
    File.open('lib/task_data.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Update the file
    end
    read_file #^No Idea why this works
  end

  def update_task
    puts "Wich task would you like to update the progress of?([task ID] [done/to do])"
    show_all
    id_to_update = gets.split
    status = id_to_update.drop(1).join(" ").downcase
    valid_status = ["done","to do"]

    @tasks.each do |task|
      if task["id"].to_i == id_to_update[0].to_i
        if valid_status.include?(status)
          task["status"] = status
          task["updated_at"] = Time.now
          update_file
          menu
        else
          puts "#{status} is not a valid status."
          menu
        end
      end
    end
    puts "#{id_to_update[0]} is not a valid ID"
    menu
  end

  def show_done
    @tasks.each {|task| puts "#{task["id"]} - #{task["to_do"]} - #{task["status"]}" if task["status"] == "done"}
  end

  def show_undone
    @tasks.each {|task| puts "#{task["id"]} - #{task["to_do"]} - #{task["status"]}" if task["status"] == "to do"}
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
