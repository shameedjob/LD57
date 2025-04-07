class_name QuickAnimation
extends Resource

@export var sprites:Array[Texture2D] = []
@export var fps:int = 8
@export var synchronous:bool = false
@export var looping:bool = false
signal frame_pass()
signal end()

func play(sprite):
	var time_to_change = 1/float(fps)
	stop_called = false
	change_sprite(sprite, sprites, time_to_change)
	
var stop_called:bool = false

func stop():
	stop_called = true
	pass
	
func change_sprite(sprite, arr_sprites:Array[Texture2D], time:float):
	frame_pass.emit()
	if stop_called and looping:
		end.emit()
		return
	sprite.texture = arr_sprites[0]
	var arr = arr_sprites.duplicate()
	arr.pop_front()
	if arr.size() == 0 and looping and not stop_called:
		change_sprite(sprite, sprites, time)
	if synchronous and arr.size() > 0:
		await sprite.get_tree().create_timer(time).timeout
		if not stop_called:
			change_sprite(sprite, arr, time)
	elif arr.size() > 0:
		sprite.get_tree().create_timer(time).timeout.connect(change_sprite.bind(sprite, arr, time), CONNECT_ONE_SHOT)
