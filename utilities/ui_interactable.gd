class_name  UIInteractable
extends Control
@export var draggable:bool = false
var dragging:bool
var entered:bool = false
var drag_offset:Vector2
static var last_object

@export_multiline var tooltip:String

signal drag_start()
signal drag_end()
signal click()
signal r_click()

func _ready():
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
	if not click.is_connected(_on_click):
		click.connect(_on_click)
	
func _on_mouse_entered():
	entered = true
	if (tooltip):
		pass
	pass # Replace with function body.
	
func _on_mouse_exited():
	entered = false
	if (tooltip):
		pass
	pass # Replace with function body.

func _process(delta):
	if (not(visible)):
		entered = false
		return
	if entered and Input.is_action_just_pressed("left_mouse"):
		last_object = self
		click.emit()
	elif entered and Input.is_action_just_pressed("right_mouse"):
		last_object = self
		r_click.emit()
		
	if (dragging):
		global_position = get_viewport().get_mouse_position() + drag_offset

	if (draggable and last_object == self):
		if (entered and Input.is_action_just_pressed("left_mouse")):
			emit_signal("drag_start")
			dragging = true
			mouse_filter = Control.MOUSE_FILTER_IGNORE
			drag_offset = global_position - get_viewport().get_mouse_position()
		elif (dragging and Input.is_action_just_released("left_mouse")):
			emit_signal("drag_end")
			mouse_filter = Control.MOUSE_FILTER_STOP
			dragging = false
	pass
	
func _on_click():
	pass
