extends CrewResource

var held_copy = null
func instantiate(sub):
	held_copy = null
	return await super.instantiate(sub)

func on_win():
	await spit_out()
		
func spit_out():
	if controller == CombatManager.instance.player_controller:
		PlayerController.instance.active_crew.append(held_copy)
	else:
		GameManager.current_enemy.team.append(held_copy)
	await controller.add_crew(held_copy)
	held_copy = null
func on_start():
	held_copy = await controller.eat_random(self)
	
func on_before_die():
	if held_copy != null:
		await spit_out()
		await controller.change_oxygen(int(get_stat("oxygen")))
