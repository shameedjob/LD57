extends Node

var save_data:Dictionary
var last_save_data:Dictionary
var file_path = "user://savegame.save"
var pw = "welcome_to_the_fyesta"


signal game_state_saved()
signal game_state_changed(dict:Dictionary)

func get_pw():
	return pw.to_utf8_buffer()
	
func try_load():
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, pw)
	if file:
		save_data = JSON.parse_string(file.get_as_text())
	else:
		save_data = {}
	last_save_data = save_data
	
func _ready():
	print(OS.get_data_dir())
	try_load()
	#reset()
	
func get_value(section:String, value:String, default = null):
	if (save_data == {}):try_load()
	
	if (not(save_data.has(section))):
		save_data[section] = {}
	if (not(save_data[section].has(value))):
		save_data[section][value] = default
		
	return save_data[section][value]

func set_value(section:String, value_name:String, value):
	if (save_data == {}):try_load()
	
	if (not(save_data.has(section))):
		save_data[section] = {}
		
	save_data[section][value_name] = value

func save():
	var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.WRITE, pw)
	file.store_line(JSON.stringify(save_data))
	game_state_saved.emit()
	
	var change_dict = DictionaryHelper.difference(save_data, last_save_data)
	if change_dict != {}:
		game_state_changed.emit(change_dict)
	last_save_data = save_data.duplicate()

func reset():
	save_data = {}
	save()
