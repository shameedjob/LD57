class_name DisconnectChildSub
extends SubControlNode

@export var disconnect_child:Node
var completed = false
@export var delay = 0
func _process(delta):
	if not completed and delay > 0:
		delay -= delta
	elif delay <= 0 and not completed:
		completed = true
		tree_exited.connect(free_obj)
		var pos = disconnect_child.global_position
		disconnect_child.reparent(parent.get_parent())
		disconnect_child.global_position = pos
	

func free_obj():
	disconnect_child.queue_free()
