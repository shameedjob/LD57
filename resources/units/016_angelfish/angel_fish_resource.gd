extends CrewResource
 
func on_other_die(other):
	if get_chance():
		if controller == CombatManager.instance.player_controller:
			PlayerController.instance.inventory_crew.append(other)
		else:
			GameManager.current_enemy.team.append(other)
	await super.on_other_die(other)
