extends Node
var shop:ShopManager
var combat
var camera:Camera2D
@onready var battle_window = $Canvas/BattleWindow

@export var all_crew:Array[CrewResource]
@export var all_enemies:Array[EnemyTeamResource]

var first_time = true
func get_main_scene():
	return get_node("/root/MainScene")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_game()
	var pa = PackedVector2Array()
	var r = 128
	var c = get_viewport().size.x/r
	for i in c+1:
		pa.append(Vector2(i*r, 0))
	for i in c+1:
		pa.append(Vector2((c-i)*r, get_viewport().size.y*100))
	$Water.polygon = pa
	
func load_game():
	add_child(load("res://resources/scenes/player_controller.tscn").instantiate())
	load_next_fight()
	shop = get_main_scene().get_node("ShopManager")
	combat = get_main_scene().get_node("CombatManager")
	load_shop()
	await fade_in()
	if first_time:
		first_time = false
		await $Beffrey.intro_tutorial()
	pass # Replace with function body.
	
func load_shop():
	shop.show()
	shop.load_items()
	
func go_to_combat():
	await fade_out()
	shop.hide()
	shop.unload()
	combat.on_ready()
	await create_tween().tween_property(get_camera(), "global_position", combat.global_position, 1.0).finished
	await fade_in()

func go_to_shop():
	await fade_out()
	combat.unload()
	load_shop()
	await create_tween().tween_property(get_camera(), "global_position", shop.global_position, 1.0).finished
	await fade_in()

func get_camera():
	return get_main_scene().get_node("Camera2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
signal enter_pressed()
func _process(delta: float) -> void:
	var base_level = 0
	if Input.is_action_just_pressed("enter"):
		enter_pressed.emit()
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	var camera_y = get_camera().position.y
	var distance = min(500, camera_y-base_level)
	var x =get_camera().position.x-get_viewport().size.x/2
	$Water.position = Vector2(x, camera_y-distance)
	pass

func game_loss():
	await $Beffrey.game_loss()
	await fade_out()
	$Canvas/Fade/LoseText.visible = true
	await enter_pressed
	get_main_scene().free()
	get_tree().root.add_child(load("res://resources/scenes/main_scene.tscn").instantiate())
	$Canvas/Fade/LoseText.visible = false
	c_round = 0
	load_game()

func game_win():
	c_round+=1
	$Canvas/RoundText.text = "[center][font_size=24]Round {round}/10".format({"round": c_round})
	if c_round >= 10:
		await $Beffrey.game_win()
		await fade_out()
		$Canvas/Fade/WinText.visible = true
		await enter_pressed
		$Canvas/Fade/WinText.visible = false
		get_main_scene().free()
		get_tree().root.add_child(load("res://resources/scenes/main_scene.tscn").instantiate())
		
		c_round = 0
		load_game()
		return
	else:
		load_next_fight()

var c_round = 0
var current_enemy:EnemyTeamResource = null

func load_next_fight():
	var options = []
	for e in all_enemies:
		if e.level_max >= c_round and e.level_min <= c_round:
			options.append(e)
	current_enemy = options.pick_random().duplicate()
	for i in current_enemy.team.size():
		current_enemy.team[i] = current_enemy.team[i].duplicate()
		current_enemy.team[i].level = current_enemy.team_levels[i]
	
func fade_out():
	var tween = create_tween()
	$Canvas/Fade.modulate = Color.TRANSPARENT
	tween.tween_property($Canvas/Fade, "modulate", Color.WHITE, 1.0)
	await tween.finished

func fade_in():
	var tween = create_tween()
	$Canvas/Fade.modulate = Color.WHITE
	tween.tween_property($Canvas/Fade, "modulate", Color.TRANSPARENT, 1.0)
	await tween.finished	
