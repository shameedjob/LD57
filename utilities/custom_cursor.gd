class_name CustomCursor
extends CanvasLayer

@export var idle_sprite:Texture2D
@export var interact_sprite:Texture2D
@export var click_sprite:Texture2D
@export var wait_animation:QuickAnimation
@onready var cursor_sprite = $CursorSprite
var base_cursor:Texture2D
var waiting = false
var focus:Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	cursor_sprite.texture = idle_sprite
	base_cursor = idle_sprite
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass # Replace with function body.
	
func add_focus(node):
	focus.append(node)
	if !waiting:
		cursor_sprite.texture = interact_sprite
	base_cursor = interact_sprite

func remove_focus(node):
	focus.erase(node)
	if focus.size() == 0:
		if !waiting:
			cursor_sprite.texture = idle_sprite
		base_cursor = idle_sprite

func check_focus():
	if focus.size() == 0:
		if !waiting:
			cursor_sprite.texture = idle_sprite
		base_cursor = idle_sprite
	
func start_wait():
	waiting = true
	wait_animation.play(cursor_sprite)
	pass
	
func stop_wait():
	waiting = false
	wait_animation.end.connect(reset_texture,CONNECT_ONE_SHOT)
	wait_animation.stop()

func reset_texture():
	cursor_sprite.texture = idle_sprite
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var nf:Array[Node] = []

	for i in focus.size():
		if focus[i] != null:
			nf.append(focus[i])
	
	if nf.size() != focus.size():
		focus = nf
		check_focus()
			
	cursor_sprite.position = cursor_sprite.get_global_mouse_position()
	if (Input.is_action_pressed("left_mouse")): _press()
	elif (Input.is_action_just_released("left_mouse")): _release()
	
	if TooltipSub.tooltip_stack.size() > 0 and is_instance_valid(TooltipSub.tooltip_stack[0]):
		$Tooltip.text = TooltipSub.tooltip_stack[0].text
		$Tooltip.global_position = ($CursorSprite.global_position+Vector2(20,20)).clamp(Vector2.ZERO, Vector2(1280, 960)-$Tooltip.size)
	pass
	
func _press():
	if (!waiting): cursor_sprite.texture = click_sprite
	
func _release():
	if (!waiting): cursor_sprite.texture = base_cursor

func show_tooltip():
	$Tooltip.size = Vector2(128 if TooltipSub.tooltip_stack[0].text.length() < 10 else 192, 0)
	$Tooltip.show()
func hide_tooltip():
	$Tooltip.hide()
