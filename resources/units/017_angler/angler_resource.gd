extends CrewResource

func on_before_die():
	await super.on_before_die()
	
	if await controller.eat_random(self):
		await controller.change_oxygen(get_stat("oxygen"))
		
