require 'json'

def cli_print(array)
  puts "====================="
  puts "Current Tasks:#{array}" if !array.nil?
  puts "You don't have any tasks yet. Good Job!" if array.nil?
  puts "====================="
end

tasks = []

if File.file?('lib/task.json')
   file = File.read('lib/task.json') #Read the current tasks if file exists
   tasks = JSON.parse(file)
   cli_print(tasks)
else
  File.open('lib/task.json','w') do |file|
    file = file.write(JSON.pretty_generate(tasks)) #Create an empty JSON if not
  end
end

puts "What task would you like to do later?"
input = gets.chomp
tasks << input
File.open('lib/task.json','w') do |file|
    file = file.write(JSON.pretty_generate(tasks)) #Update the file
  end
p tasks
