class_name CombatManager
extends Node

var depth = 0
var depth_t:float = 0 #depth tween; display only
var diving = false
var in_combat = false
static var instance:CombatManager

var player_controller:SubmarineController
var enemy_controller:SubmarineController

var depth_text_format = "[center][font_size=36]Depth {depth}M"
var oxygen_text_format = "[center][font_size=24]{oxy}[img width=36]sprites/bubble.png[/img]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance = self
	
func on_ready():
	GameManager.battle_window.get_node("DepthWindow").visible = true
	GameManager.battle_window.get_node("EnemyGameUI").visible = true
	create_subs()
	stat_update()
	await game_start()
	$TurnTimer.start()
	#Wait 3 seconds for game start functions
	pass # Replace with function body.


func _process(delta: float) -> void:
	GameManager.battle_window.get_node("DepthWindow").text = depth_text_format.format({"depth": int(depth_t)})
	if in_combat:
		player_controller.can_object.apply_force((depth_t*16-player_controller.can_object.position.y)*Vector2(0,1))
		enemy_controller.can_object.apply_force((depth_t*16-enemy_controller.can_object.position.y)*Vector2(0,1))
		GameManager.get_camera().global_position = (player_controller.can_object.global_position + enemy_controller.can_object.global_position)/2
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func turn_pass():
	diving = false
	await do_turn_effects()
	await death_check()
	if not in_combat:
		return
	
	
	$TurnTimer.start()
	depth += 10
	var tween = create_tween()
	tween.tween_property(self, "depth_t", depth, $TurnTimer.wait_time)
	diving = true
	
func get_order():
	var arr = [player_controller, enemy_controller]
	arr.sort_custom(
		func(a:SubmarineController, b:SubmarineController):
			return a.get_speed_return() > b.get_speed_return()
	)
	return arr
	
func do_turn_effects():
	var arr = get_order()
	
	for c in arr:
		await c.turn_pass()
		
	for c in arr:
		c.change_oxygen(-depth/10)
	await get_tree().create_timer(1.0)
	pass

func get_opponent(controller:SubmarineController):
	if controller == player_controller:
		return enemy_controller
	return player_controller
func create_subs(player=null, enemy=null):
	player_controller = SubmarineController.create_sub()
	enemy_controller = SubmarineController.create_sub()

	player_controller.load_crew(PlayerController.instance.active_crew)
	enemy_controller.load_crew(GameManager.current_enemy.team)
	
	player_controller.position = Vector2.LEFT * 200
	enemy_controller.position = Vector2.RIGHT * 200
	add_child(player_controller)
	add_child(enemy_controller)
	pass
	
func stat_update():
	GameManager.battle_window.get_node("EnemyGameUI/Stats/OxygenText").text = oxygen_text_format.format({"oxy": enemy_controller.oxygen})
	GameManager.battle_window.get_node("PlayerGameUI/Stats/OxygenText").text = oxygen_text_format.format({"oxy": player_controller.oxygen})
	pass

func game_start():
	in_combat = true
	for a in get_order():
		await a.game_start()
	pass

func death_check():
	var subs = []
	if player_controller.oxygen <= 0:
		subs.append(player_controller)
	if enemy_controller.oxygen <= 0:
		subs.append(enemy_controller)
	
	subs.sort_custom(
		func(a:SubmarineController, b:SubmarineController):
			return a.get_speed_return() > b.get_speed_return()
	)
	
	for s in subs:
		await s.before_die()
	
	if not player_controller.dead() and enemy_controller.dead():
		await  enemy_controller.die()
		win()
		pass
	elif player_controller.dead():
		
		enemy_controller.die()
		lose()
		pass
		
func win():
	if not in_combat: return
	GameManager.battle_window.get_node("WinText").visible = true
	in_combat = false
	await player_controller.on_win()
	await get_tree().create_timer(2.0).timeout
	PlayerController.instance.change_bucks(5)
	PlayerController.instance.win_experience()
	GameManager.game_win()
	GameManager.go_to_shop()

func lose():
	if not in_combat: return
	GameManager.battle_window.get_node("LoseText").visible = true
	in_combat = false
	await get_tree().create_timer(2.0).timeout
	if not await kill_player_units():
		GameManager.go_to_shop()
	
	
func before_die():
	pass
	
func die():
	pass

func unload():
	depth = 0
	depth_t = 0
	$TurnTimer.stop()
	GameManager.battle_window.lose_text.visible = false
	GameManager.battle_window.win_text.visible = false
	GameManager.battle_window.get_node("DepthWindow").visible = false
	GameManager.battle_window.enemy_game_ui.visible = false
	GameManager.battle_window.depth_window.visible = false
	GameManager.battle_window.get_node("PlayerGameUI/Stats/OxygenText").text = oxygen_text_format.format({"oxy": 100})
	player_controller.queue_free()
	enemy_controller.queue_free()

func kill_player_units():
	await player_controller.die()
	if PlayerController.instance.inventory_crew.size() <= 0:
			return false
