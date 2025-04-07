class_name StringHelper

static func string_to_vector2(string) -> Vector2:
	if string is Vector2:
		return string
	if string is String:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(int(array[0]), int(array[1]))

	return Vector2.ZERO
