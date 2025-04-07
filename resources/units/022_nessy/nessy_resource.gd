extends CrewResource

func on_death(other):
	await controller.change_oxygen(get_stat("oxygen"))
	await CombatManager.instance.get_opponent(controller).change_oxygen(-get_stat("oxygen"))
