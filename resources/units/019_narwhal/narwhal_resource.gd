extends CrewResource

var triggered = false
func instantiate(sub):
	triggered = false
	return super.instantiate(sub)
	
func on_before_die():
	if not triggered:
		triggered = true
		await CombatManager.instance.get_opponent(controller).eat_random()
		await controller.change_oxygen(get_stat("oxygen"))
		await super.on_die()
