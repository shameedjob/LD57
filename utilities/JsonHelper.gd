class_name JsonHelper

static func get_value_from_json(json:JSON, path:String):
	var pointer = json.data
	for p in path.split(" "):
		if pointer.has(p):
			pointer = pointer[p]
	
	return pointer
