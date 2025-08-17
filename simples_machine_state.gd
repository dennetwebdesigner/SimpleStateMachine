extends Node

class_name Simple_State_Machine

var current := ""
var _actions := {}
var started := false
var _dispatch_map := {}

var state_machine = null

func add_action(state: String, start_func: Callable, update_func: Callable):
  var temp_action = {
    start = start_func,
    update = update_func
  }

  var keys = temp_action.keys()
  if keys.size() != 2 or not ("start" in keys and "update" in keys):
    push_error("Ação deve conter somente as chaves 'start' e 'update'")
    return

  if not start_func.is_valid():
    push_error("start_func inválido ou não é Callable")
    return
  if not update_func.is_valid():
    push_error("update_func inválido ou não é Callable")
    return

  if update_func.get_argument_count() != 1:
    push_warning("update_func deve receber 1 argumento (delta)")
    return


  if not state in _actions:
    _actions[state] = []

  _actions[state].append({
    start = start_func,
    update = update_func
  })

func set_state(new_state: String):
  if new_state == current: return

  current = new_state
  started = false

func add_dispatch(event_name: String, state_name: String) -> void:
    _dispatch_map[event_name] = state_name

func dispatch(event_name: String):
  if event_name in _dispatch_map:
    set_state(_dispatch_map[event_name])
  else:
    print("Evento não encontrado no dispatch:", event_name)

func ready():
  if state_machine:
    state_machine.call()

func loop(delta):
  if current == "":
      return
    
  if not started:
    for action in _actions.get(current, []):
        action.start.call()
    started = true

  for action in _actions.get(current, []):
      action.update.call(delta)
