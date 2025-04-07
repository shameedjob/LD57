extends CrewResource

func get_name_to_arr(arr):
	for i in get_stat("count"):
		for c in controller.crew:
			arr.append(c.resource.name)
