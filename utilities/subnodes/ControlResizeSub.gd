class_name ControlResizeSub
extends SubControlNode

@export var trans_type:Tween.TransitionType = Tween.TRANS_LINEAR

@export_category("Open")
@export var open_time:float
@export var open_size:Vector2

@export_category("Close") 
@export var close_time:float
@export var close_size:Vector2

signal open_finish()
signal close_finish()

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()

func resize_open():
	var tween = create_tween()
	parent.size = close_size
	tween.tween_property(parent, "size",  open_size, open_time).set_trans(trans_type)
	await tween.finished
	open_finish.emit()
	
func resize_close():
	var tween = create_tween()
	tween.tween_property(parent, "size",  close_size, close_time).set_trans(trans_type)
	await tween.finished
	close_finish.emit()
	
