class_name DevConsole
extends CanvasLayer

@export var toggle_action:String = "test"
var showing = false
@export var text_input:LineEdit
@export var text_holder:Control
@export var text_prefab:RichTextLabel 
@export var command_start = "-"
var was_paused = false
var command_dict:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	showing = false
	visible = false
	text_input.text_submitted.connect(on_command_input_text_changed)
	command_dict["help"] = [help_command, "Displays all commands"]
	pass # Replace with function body.

func help_command(args:PackedStringArray):
	print_command_line("[color=blue]List of all commands:")
	for d in command_dict:
		print_command_line("\t-"+d+"\t "+command_dict[d][1])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed(toggle_action) and can_toggle():
		toggle()
	pass
	
func can_toggle()->bool:
	return false

func toggle():
	if not showing:
		was_paused = get_tree().paused
		visible = true
		showing = true
		get_tree().paused = true
		text_input.grab_focus()
	else:
		get_tree().paused = false
		visible = false
		showing = false

func process_command_start(command_line:String):
	print_command_line(command_line)
	if command_line.begins_with(command_start):
		var parameters = command_line.substr(command_start.length()).split(" ")
		command_process(parameters)
	refresh_selection()
	
func refresh_selection():
	text_input.grab_focus()
	text_input.text = ""
	
func print_command_line(input:String):
	var new_text = text_prefab.duplicate()
	text_holder.add_child(new_text)
	new_text.text = input
	new_text.visible = true
	pass
	
func print_success_line(input:String):
	print_command_line("[color=green]"+input)

func print_error_line(input:String):
	print_command_line("[color=red]"+input)
	
func command_process(params:PackedStringArray):
	var found  = false
	for d in command_dict:
		if params[0].to_lower() == d.to_lower():
			found = true
			command_dict[d][0].call(params)
	if not found:
		print_error_line("Command not recognized: "+params[0])


func on_command_input_text_changed(input):
	process_command_start(input)
	pass # Replace with function body.

func check_length_format(params:PackedStringArray, error:String, start:int, end:int = 999)->bool:
	if params.size() >= start and params.size() <= end:
		return false
	print_error_line(error)
	return true
	
