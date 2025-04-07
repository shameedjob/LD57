extends CrewResource
var triggered = false
func instantiate(sub):
	triggered = false
	return super.instantiate(sub)
	pass
	
func on_before_die():
	if not triggered:
		triggered = true
		await controller.change_oxygen(int(get_stat("oxygen")))
	pass
