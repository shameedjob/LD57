extends AttackCrewResource
var d_mod = 0
func instantiate(sub):
	d_mod = get_stat("damage")
	return await super.instantiate(sub)

func do_attack():
	await CombatManager.instance.get_opponent(controller).change_oxygen(-d_mod)
	d_mod += get_stat("damage")
	
