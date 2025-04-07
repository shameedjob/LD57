extends Node2D
@export var textures:Array[Texture2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 5:
		create_guts()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_guts():
	var gut = $obj.duplicate()
	add_child(gut)
	gut.get_child(0).texture = textures.pick_random()
	gut.show()
	gut.freeze = false
	gut.linear_velocity = Vector2.RIGHT.rotated(PI*2*randf()) * 100
