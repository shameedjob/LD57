class_name  CursorHoverSub
extends SubControlNode

@export var detection_area:Node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detection_area.mouse_entered.connect(mouse_entered)
	detection_area.mouse_exited.connect(mouse_exited)

	pass # Replace with function body.

var hovered = false
var busy = false
func mouse_entered():
	hovered  = true
	CursorWindow.add_focus(parent)
	pass

func mouse_exited():
	hovered = false
	CursorWindow.remove_focus(parent)
	pass
