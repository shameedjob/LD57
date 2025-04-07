extends CrewResource

func on_turn_pass():
	if get_chance():
		var unit = controller.crew.pick_random().resource
		unit.temp_data.data["oxygen_cost"] = 0
	await super.on_turn_pass()
