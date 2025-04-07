extends CrewResource

func on_die():
	if controller == CombatManager.instance.player_controller:
		var choices = []
		if level == 1:
			PlayerController.instance.change_bucks(1)
			return
		elif level == 2:
			for c in GameManager.all_crew:
				if c.tier == GameManager.c_round/2+1:
					choices.append(c)
		elif level == 3:
			for c in GameManager.all_crew:
				if c.tier == GameManager.c_round/2+2:
					choices.append(c)
		PlayerController.instance.active_crew.append(choices.pick_random())
	await super.on_die()
