class_name SubmarineController
extends Node2D

var oxygen = 100
static var base_sub_control = preload("res://resources/scenes/submarine_controller.tscn")
# Called when the node enters the scene tree for the first time

@onready var can_object:RigidBody2D = $Can
var crew:Array[CrewObject]

func load_crew(arr:Array[CrewResource]):
	for c in arr:
		add_crew(c)
		
func add_crew(c):
	var obj = c.instantiate(self)
	if self == CombatManager.instance.enemy_controller:
		obj.get_node("Sprite").flip_h = true
		obj.get_node("Sprite/EyeSprite").position += Vector2(-obj.get_node("Sprite/EyeSprite").position.x*2, 0)
		
	obj.linear_velocity = Vector2.RIGHT.rotated(randf()*PI*2) * 100
	$Can/CanSprite2.add_child(obj)
	crew.append(obj)


func change_oxygen(amt):
	oxygen += amt
	CombatManager.instance.stat_update()
	
func die():
	for c in crew:
		await c.resource.on_eat()
	$Can/CanSprite.visible = false
	$Can/CanSprite2.self_modulate = Color.TRANSPARENT
	$Can/CanSprite2.clip_children = 0
	for c in $Can.get_children():
		if "wall" in c.name:
			c.queue_free()
func before_die():
	for c in crew:
		await c.resource.on_before_die()
		if oxygen > 0: return

func get_can_pos():
	return $Can.global_position
	
func attack_effect():
	var opponent = CombatManager.instance.get_opponent(self)
	var pos = (opponent.get_can_pos() - get_can_pos())
	$Can.apply_impulse(pos*1.25)
	await get_tree().create_timer(1.0).timeout
	for c in crew:
		await c.resource.on_attack()
	await CombatManager.instance.get_opponent(self).on_attacked()
	pass

func turn_pass():
	for c in crew:
		await c.resource.on_turn_pass()
		await change_oxygen(-c.resource.get_oxygen_cost())
		await CombatManager.instance.death_check()

func game_start():
	for c in crew:
		await c.resource.on_start()
		await CombatManager.instance.death_check()

static func create_sub():
	return base_sub_control.instantiate()
	
func get_speed_return():
	var cost = 0
	for c in crew:
		cost += c.resource.get_oxygen_cost()
	return cost

func on_win():
	for c in crew: 
		await c.resource.on_win()

func on_attacked():
	for c in crew:
		await c.resource.on_attacked()
		
func eat_random(obj = null):
	var edible = []
	for c in crew:
		if c.resource.edible and c.resource != obj:
			edible.append(c.resource)
	if edible.size()> 0:
		var r = edible.pick_random()
		await r.on_eat()
		return r
	return false
func _physics_process(delta: float) -> void:
	$RopeLine.set_point_position(1, get_can_pos()-global_position)
	$Can.apply_force((-$Can.position.x)*Vector2.RIGHT*delta*100)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func dead():
	return oxygen <= 0 or crew.size() <= 0
