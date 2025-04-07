extends NameCountCrewResource

func on_start():
	var i = get_names()-1
	if i > 0:
		await controller.change_oxygen(i*get_stat("oxygen"))
	pass
