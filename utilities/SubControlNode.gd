class_name SubControlNode
extends Node
var parent:
	get:
		
		return get_parent() if override_parent == null else override_parent

@export var override_parent:Node

func _ready():
	pass
	
static func get_sub_node(node:Node, type:Variant):
	for c in node.get_children():
		if not (c is SubControlNode):
			continue
		if is_instance_of(c, type):
			return c
	return null
