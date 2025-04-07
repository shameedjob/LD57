extends Control

@export var speed = 0
@export var rsnge = 90
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0
func _process(delta):
	var center = size/2
	var count = get_child_count()
	for i in range(count):
		center + Vector2.RIGHT.rotated(deg_to_rad(i * 360/count + time))
	time = fmod(time + delta*speed, 360)
	pass
