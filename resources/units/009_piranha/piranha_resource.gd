extends NameCountCrewResource

func on_turn_pass():
	if get_names() > 1:
		await attack()

func attack():
	await instance.attack_effect()
	await controller.attack_effect()
	await do_attack()
	
func do_attack():
	var i = get_names()-1
	CombatManager.instance.get_opponent(controller).change_oxygen(-get_stat("damage")*i)
