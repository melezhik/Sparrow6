from glue import *
import json

TASK_VARIABLES = None
CONFIG = None
CAPTURES = None
STREAMS = None
STREAMS_ARRAY = None

def set_stdout(line):
  with open(stdout_file(), "a") as myfile:
    myfile.write(line)
  
def config():

  global CONFIG

  if CONFIG:
    return CONFIG
  else:
    json_file = cache_root_dir() + "/config.json"
    with open(json_file) as data_file:
      CONFIG = json.load(data_file)
    return CONFIG
  

def run_task( path, params = [] ):

    print "task_var_json_begin"
    if bool(params):
      print json.dumps(params, ensure_ascii=False)
    else:
      print "{}"

    print "task_var_json_end"
    print "task: " + path

# this syntax is deprecated
# use `ignore_error` instead

def ignore_task_error(val):
  print "ignore_task_error: " + str(val)

def ignore_error():
  print "ignore_task_error: "

def task_variables():

  global TASK_VARIABLES

  if TASK_VARIABLES:
    return TASK_VARIABLES
  else:
    json_file = cache_dir() + "/variables.json"
  
    with open(json_file) as data_file:
      TASK_VARIABLES = json.load(data_file)
  
    return TASK_VARIABLES
  

def task_var(name):

  return task_variables()[name]


def captures():

  global CAPTURES

  if CAPTURES:
    return CAPTURES
  else:
    json_file = cache_root_dir() + "/captures.json"
    with open(json_file) as data_file:
      data = json.load(data_file)

    CAPTURES = list(map(lambda x: x.get('data'), data))

    return  CAPTURES
    
def capture():
    return captures()[0]


def streams():

  global STREAMS

  if STREAMS:
    return STREAMS
  else:
    json_file = cache_root_dir() + "/streams.json"
    with open(json_file) as data_file:
      STREAMS = json.load(data_file)
    return STREAMS


def streams_array():

  global STREAMS_ARRAY

  if STREAMS_ARRAY:
    return STREAMS_ARRAY
  else:
    json_file = cache_root_dir() + "/streams-array.json"
    with open(json_file) as data_file:
      STREAMS_ARRAY = json.load(data_file)
    return STREAMS_ARRAY


def get_state():

  json_file = cache_root_dir() + "/state.json"
  with open(json_file) as data_file:
    return json.load(data_file)


def update_state(state):

  json_file = cache_root_dir() + "/state.json"

  with open(json_file, "w") as myfile:
    myfile.write(json.dumps(state))



