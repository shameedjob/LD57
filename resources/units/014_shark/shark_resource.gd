extends AttackCrewResource

func do_attack():
	await CombatManager.instance.get_opponent(controller).eat_random()
	pass
