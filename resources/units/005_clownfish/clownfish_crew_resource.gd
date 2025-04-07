extends CrewResource

func on_attack():
	await controller.change_oxygen(get_stat("oxygen"))
	pass
