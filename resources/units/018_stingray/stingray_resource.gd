extends CrewResource

func on_attacked():
	if get_chance():
		await CombatManager.instance.get_opponent(controller).eat_random()
