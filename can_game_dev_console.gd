extends DevConsole

func _ready() -> void:
	super._ready()
	command_dict["lose"] = [cmd_lose, "Calls a lose command"]
	command_dict["win"] = [cmd_win, "Calls a win command"]
	command_dict["add_crew"] = [add_to_crew, "add to crew"]
	command_dict["add_enemy_crew"] = [add_enemy_crew, "add to crew"]
	command_dict["set_round"] = [set_round, "set round"]


func cmd_lose(params):
	GameManager.game_loss()
	
func cmd_win(params):
	GameManager.c_round = 9
	GameManager.game_win()
	

func set_round(params):
	GameManager.c_round = int(params[1])
	GameManager.load_next_fight()
	
func add_enemy_crew(params):
	PlayerController.instance.active_crew.clear()
	for i in range(1, params.size()):
		if params[i].is_valid_int():
			var ind = int(params[i])
			if ind < GameManager.all_crew.size():
				GameManager.current_enemy.team.append(GameManager.all_crew[ind].duplicate())
				
func add_to_crew(params):
	PlayerController.instance.active_crew.clear()
	for i in range(1, params.size()):
		if params[i].is_valid_int():
			var ind = int(params[i])
			if ind < GameManager.all_crew.size():
				PlayerController.instance.active_crew.append(GameManager.all_crew[ind].duplicate())
				GameManager.shop.update_go_button()
		
