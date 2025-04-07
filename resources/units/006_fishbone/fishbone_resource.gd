extends CrewResource

func on_die():
	if controller != CombatManager.instance.player_controller:
		return
	if get_chance():
		PlayerController.instance.inventory_crew.append(duplicate())
	await super.on_die()
