
require 'glue'
require 'json'

if File.exist? "#{task_dir}/common.rb"

  require "#{task_dir}/common.rb"

end

if File.exist? "#{root_dir}/common.rb"

  require "#{root_dir}/common.rb"

end

def set_stdout line
  open(stdout_file(), 'a') do |f|
    f.puts "#{line}\n"
  end
end


def run_task path, params = {}

    puts "task_var_json_begin"
    puts params.to_json
    puts "task_var_json_end"
    puts "task: #{path}"

end

# this syntax is deprecated
# use `ignore_error` instead

def ignore_task_error val = nil
  puts "ignore_task_error:"
end

def ignore_error val = nil
  puts "ignore_error:"
end

def ignore_task_check_error val = nil
  puts "ignore_task_check_error:"
end

def captures
   @captures ||=  JSON.parse(File.read("#{cache_root_dir}/captures.json")).map { |c|  c['data'] }  
end

def capture
    captures.first
end

def task_variables 
   @task_varaibles ||= JSON.parse(File.read("#{cache_dir}/variables.json"))  
end

def task_var name
  task_variables[name]
end

def config
   @config ||= JSON.parse(File.read("#{cache_root_dir}/config.json"))  
end

def streams
   @streams ||= JSON.parse(File.read("#{cache_root_dir}/streams.json"))  
end

def streams_array
   @streams_array ||= JSON.parse(File.read("#{cache_root_dir}/streams-array.json"))  
end

def get_state
   JSON.parse(File.read("#{cache_root_dir}/state.json"))  
end

def update_state state
   File.write("#{cache_root_dir}/state.json",state.to_json) 
end
