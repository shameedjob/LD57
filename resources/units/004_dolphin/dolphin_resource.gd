extends CrewResource

func on_turn_pass():
	if randi_range(0, get_stat("chance_t")) <= get_stat("chance_h"):
		await controller.change_oxygen(get_stat("oxygen"))
		
