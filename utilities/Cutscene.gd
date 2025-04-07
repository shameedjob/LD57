class_name Cutscene
extends Node

signal completed()

func start_cutscene():
	while (MainSceneController.instance == null):
		await get_tree().physics_frame
		pass
	pass
	
func on_complete():
	completed.emit();
	pass
