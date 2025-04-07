extends CrewResource

func on_win():
	if get_chance():
		await PlayerController.instance.change_bucks(get_stat("gain"))
