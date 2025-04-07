class_name CrewResource
extends Resource

@export var name:StringName = "Fish"
@export var oxygen_cost:int = 1
@export var tier:int = 1
@export var data:JSON
var temp_data:JSON

@export var sprite:Texture2D = preload("res://sprites/fish.png")

@export var level = 1
@export var edible = true
var experience = 0
var controller:SubmarineController
var instance:CrewObject = null
static var scene_obj = preload("res://resources/scenes/crew.tscn")

@export_multiline var description = "Description"
@export var eye_pos: Vector2
func instantiate(sub):
	controller = sub
	instance = scene_obj.instantiate()
	instance.set_up(self)
	if data:
		temp_data = data.duplicate()
	return instance
	
func tooltip_text():
	var template = "[center][color=black]{name} {tier}\n[img width=24]sprites/bubble.png[/img]{cost}\nLV.{level}: [{exp}/{r_exp}]\n[left]{description}"
	return template.format({"name": name, "cost": get_stat("oxygen_cost"), "description": get_description(),"level":level, "exp":(experience), "r_exp":max_exp(), "tier":get_tier()})

func get_tier():
	var arr = [
		"black",
		"#00D000",
		"orange",
		"blue",
		"purple",
		"red"
	]
	return "[color={color}](T{tier})[/color]".format({"color": arr[tier], "tier": tier})
func find_template_arrs():
	var arr = []
	var regex = RegEx.new()
	regex.compile("{(.*?)}")
	var matches = regex.search_all(description)
	
	for m in matches:
		arr.append(m.strings[1])
	return arr
	
	
func get_description():
	var arr = find_template_arrs()
	var replaced_data = {}
	if not data: return description
	for d in arr:
		replaced_data[d] = get_stat(d)
		#if data.data[d] is Dictionary:
			#for l in data.data[d]:
				#replaced_data[l] = get_stat(l)
		#else:
			#replaced_data[d] = get_stat(d)
	
	var nd = description.format(replaced_data)
	description = description.replace(" (O)", "[img width=24]sprites/bubble.png[/img]")
	description = description.replace("(O)", "[img width=24]sprites/bubble.png[/img]")
	return nd
func on_before_die():
	pass

func on_start():
	pass
	
func on_win():
	pass
	
func on_eat():
	EffectManager.create_effect("res://resources/audio/effects/eaten_death.tscn", instance)
	await on_die()
	pass
	
func on_die():
	await on_before_die()
	if controller == CombatManager.instance.player_controller:
		PlayerController.instance.active_crew.erase(self)
	else:
		GameManager.current_enemy.team.erase(self)
	
	controller.crew.erase(instance)
	for c in controller.crew:
		await c.resource.on_other_die(self)
	for a in CombatManager.instance.get_opponent(controller).crew:
		await a.resource.on_enemy_die(self)
		
	instance.queue_free()
	pass

func on_other_die(other):
	await on_death(other)
	pass
	
func on_enemy_die(other):
	await on_death(other)
	pass
	
func on_death(other):
	pass
func on_attacked():
	pass
	
func on_game_end():
	pass
	
func on_turn_pass():
	pass

func on_level_up():
	pass
	
func on_lose_oxygen():
	pass
	
func max_exp():
	return level * 2

func gain_exp():
	if level >= 3:
		return
		
	experience += 1
	if experience >= max_exp():
		experience -= max_exp()
		level += 1
		on_level_up()
		experience -= 1
		gain_exp()
func get_stat(stat_name):
	if temp_data == null:
		temp_data = self.data
	var data = temp_data
	if data:
		if stat_name in data.data:
			return data.data[stat_name]
		if str(level) in data.data:
			if stat_name in data.data[str(level)]:
				return data.data[str(level)][stat_name]
	if stat_name in self:
		return self[stat_name]
		
func change_stat(stat_name, stat_value):
	if temp_data == null:
		temp_data = self.data
	var data = temp_data
	if data:
		if stat_name in data.data:
			data.data[stat_name] = stat_value
			return
		if str(level) in data.data:
			if stat_name in data.data[str(level)]:
				data.data[str(level)][stat_name] = stat_value
				return
	if stat_name in self:
		self[stat_name]=stat_value
		return
		
func get_oxygen_cost():
	return get_stat("oxygen_cost")

func get_name_to_arr(name_arr):
	name_arr.append(name)

func on_attack():
	pass

func get_chance(): 
	return randi_range(0, get_stat("chance_t")) <= get_stat("chance_h")
