extends AttackCrewResource
func try_attack():
	if CombatManager.instance.get_opponent(controller).crew.size() < 4:
		await attack()

func do_attack():
	CombatManager.instance.get_opponent(controller).change_oxygen(
		-get_stat("damage")*(4-CombatManager.instance.get_opponent(controller).crew.size()))
