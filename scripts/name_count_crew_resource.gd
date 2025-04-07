class_name NameCountCrewResource
extends  CrewResource

func get_names():
	var arr = []
	for c in controller.crew:
		c.resource.get_name_to_arr(arr)
	var count = 0
	
	for a in arr:
		if a == name:
			count += 1
	return count
