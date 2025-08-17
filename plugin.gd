extends EditorPlugin

var state_machine_script

func _enter_tree():
    state_machine_script = preload("res://simple_state_machine.gd")
    add_custom_type("SimpleStateMachine", "Node", state_machine_script, null)

func _exit_tree():
    remove_custom_type("StateMachine")