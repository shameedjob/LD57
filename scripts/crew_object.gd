class_name CrewObject
extends RigidBody2D
var resource:CrewResource


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_up(res:CrewResource):
	resource = res
	$Sprite/EyeSprite.position = res.eye_pos
	$Sprite.texture = res.sprite

func attack_effect():  
	var dist = CombatManager.instance.get_opponent(resource.controller).get_can_pos() - global_position
	apply_impulse(dist+Vector2.UP*400)
	await get_tree().create_timer(0.25).timeout

func get_custom_tooltip_text():
	return resource.tooltip_text()
