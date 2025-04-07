class_name SaveVisibilityNode
extends Node
@export var value_section:String
@export var value_label:String
@export var value_to_compare:String
@export var compare_value:CompareType
@export var delete:bool  = false

enum CompareType{
	LT, GT, EQ, LE, GE, NE, EXISTS
}

func _ready():
	var parent = get_parent()
	if not parent:
		var check_state = false
		var value = SaveManager.get_value(value_section, value_label)
		if value != null:
			match compare_value:
				CompareType.LT:
					check_state = compare_value < value
				CompareType.GT:
					check_state = compare_value > value
				CompareType.EQ:
					check_state = compare_value == value
				CompareType.LE:
					check_state = compare_value <= value
				CompareType.GE:
					check_state = compare_value >= value
				CompareType.NE:
					check_state = compare_value != value
		parent.visible = check_state
		if parent.visible == false and delete:
			parent.queue_free()
		
