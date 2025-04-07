class_name  TooltipSub
extends SubControlNode

static var tooltip_stack: Array

@export var detection_area:Node
var tooltip_format = ""
@export var text_override:String
var text:
	get:
		if text_override != "":
			return parent.call(text_override)
		return parent.get_custom_tooltip_text()
var timer:Timer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detection_area.mouse_entered.connect(mouse_entered)
	detection_area.mouse_exited.connect(mouse_exited)
	timer = Timer.new()
	timer.wait_time = 0.25
	add_child(timer)
	pass # Replace with function body.

var hovered = false
var busy = false
func mouse_entered():
	hovered  = true
	for i in tooltip_stack.duplicate():
		if not is_instance_valid(i):
			tooltip_stack.erase(i)
	
	tooltip_stack.push_front(self)
	if not Input.is_action_pressed("shift"):
		timer.timeout.connect(
			func():
				if hovered:
					CursorWindow.show_tooltip()
		, CONNECT_ONE_SHOT
		)
	else:
		CursorWindow.show_tooltip()
	timer.start()
	pass

func mouse_exited():
	hovered = false
	
	timer.stop()
	tooltip_stack.erase(self)
	for i in tooltip_stack.duplicate():
		if not is_instance_valid(i):
			tooltip_stack.erase(i)
	
	await get_tree().create_timer(0.25).timeout
	if tooltip_stack.size() <= 0:
		CursorWindow.hide_tooltip()
	pass
