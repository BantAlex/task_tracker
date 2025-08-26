require 'json'
#TODO Take care of the file?, update_file and read_file trio.
class TaskTracker
  attr_accessor :tasks

  def initialize
    puts "          >Task Tracker v1.03<          "
    @tasks = []
    file?
    update_file
    menu
  end

  def read_file
    file = File.read('lib/task_data.json')
    @tasks = JSON.parse(file)
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
    puts "showallupdates- Show all tasks with the last updated time"
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
      when "showallupdates" then show_all_updates
      when "done" then show_done
      when "todo" then show_undone
      when "clearlist" then clear_list
      when "exit" then exit
      else puts "Invalid Option"
    end
    menu
  end

  def add_task(task)
    generate_id = 1 if @tasks.empty?
    generate_id = @tasks.last["id"].to_i + 1 if !@tasks.empty?

    new_task = {
        to_do: task,
        id: generate_id,
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
      @tasks.each_with_index do |task,index|
         if task["to_do"].downcase == via_task.downcase
           @tasks.delete_at(index)
           task_found = true
           puts "Task #{via_task} deleted succesfully"
           menu
         end
         puts "#{via_task} does not exist in your list." if !task_found
      end
    end

    if via_id
      @tasks.each_with_index do |task,index|
        if task["id"].to_i == via_id.to_i
          @tasks.delete_at(index)
          id_found = true
          puts "Task #{via_id} deleted succesfully"
          menu
        end
        puts "#{via_id} does not exist in your list." if !id_found
      end
    end

    update_file
    show_all
   end

  def show_all
    @tasks.each {|task| puts "#{task["id"]} - #{task["to_do"]} - #{task["status"]}"}
  end

  def show_all_updates
    @tasks.each {|task| puts "#{task["id"]} - #{task["to_do"]} - #{task["status"]} - #{task["updated_at"]}"}
  end

  def update_file #^No Idea why this entangled mess works
    File.open('lib/task_data.json','w') do |file|
        file = file.write(JSON.pretty_generate(@tasks)) #Update the file
    end
    read_file #^No Idea why this entangled mess works
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
      update_file
      menu
    elsif terminate == "n"
      menu
    else
      puts "Not a Valid Option"
    end
  end

end
