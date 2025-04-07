class_name DisconnectParentSub
extends SubControlNode

var completed = false
@export var delay = 0
func _process(delta):
	if not completed and delay > 0:
		delay -= delta
	elif delay <= 0 and not completed:
		completed = true
		var pos = parent.global_position
		parent.reparent(parent.get_parent().get_parent())
		parent.global_position = pos
		parent.tree_exited.connect(free_obj)
	

func free_obj():
	parent.queue_free()
	
