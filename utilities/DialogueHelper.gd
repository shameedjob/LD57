class_name DialogueHelper
static var text_containers = []
static func get_script_from_json(json:JSON, path:String):
	var pointer = JsonHelper.get_value_from_json(json, path)
	if pointer.has("text"):
		return pointer
	else: return null
	
static func speak(script: Dictionary, text_object:RichTextLabel, audio_controller:AudioStreamPlayer, talk_callable:Variant = null):
	text_containers.append(text_object)
	var alphabet = 'aeioubcdfghjklmnpqrstvwxyz'
	for a in script["text"]:
		var template = "[color=black][font_size=12]"
		if script.has("template"):
			template = script["template"]
		var text_speed = 1/17.5
		if script.has("speed"):
			text_speed = 1/script["speed"]
		text_object.text = template+a
		text_object.visible_ratio = 0
		var total_characters = text_object.get_total_character_count()
		for i in (total_characters):
			if not is_instance_valid(text_object): return
			text_object.visible_characters = i+1
			var ind = text_object.get_parsed_text()[i-1]
			if ind in alphabet:
				audio_controller.play(float(alphabet.find(ind))/2.0)
				audio_controller.get_tree().create_timer(0.5).timeout.connect(audio_controller.stop)
				if talk_callable:
					talk_callable.call()
				pass
			if not Input.is_action_pressed("shift"):
				var timer = text_object.get_tree().create_timer(text_speed)
				await  timer.timeout
			else:
				var timer = text_object.get_tree().create_timer(text_speed/4)
				await  timer.timeout
			if text_containers.count(text_object) > 1:
				break
		if text_containers.count(text_object) > 1:
			break
		if not is_instance_valid(text_object): return
		await text_object.get_tree().create_timer(0.65).timeout
	text_containers.erase(text_object)


static func read(script: Dictionary, text_object:RichTextLabel, talk_callable:Variant = null):
	text_containers.append(text_object)
	for a in script["text"]:
		var template = "[color=black][font_size=12]"
		if script.has("template"):
			template = script["template"]
		var text_speed = 1/17.5
		if script.has("speed"):
			text_speed = 1/script["speed"]
		text_object.text = template+a
		text_object.visible_ratio = 0
		var total_characters = text_object.get_total_character_count()
		for i in (total_characters):
			if not is_instance_valid(text_object): return
			text_object.visible_characters = i+1
			if talk_callable:
				talk_callable.call()
			if not Input.is_action_pressed("shift"):
				var timer = text_object.get_tree().create_timer(text_speed)
				await  timer.timeout
			else:
				var timer = text_object.get_tree().create_timer(text_speed/4)
				await  timer.timeout
			if text_containers.count(text_object) > 1:
				break
		if text_containers.count(text_object) > 1:
			break
		if not is_instance_valid(text_object): return
		await text_object.get_tree().create_timer(0.65).timeout
	text_containers.erase(text_object)
