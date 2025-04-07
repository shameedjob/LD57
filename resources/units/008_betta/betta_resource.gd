extends CrewResource

func on_attacked():
	if get_chance():
		await controller.change_oxygen(get_stat("oxygen"))
