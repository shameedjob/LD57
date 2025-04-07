@tool
class_name UIInteractableTextButton
extends UIInteractable
@export var template = "[font_size=14][color=black]{0}"
var _text = "" 
@export var text:String: set = set_text, get = get_text
@export var override_view:Control = null
var _oview

var _disabled:bool = false
@export var disabled:bool:
	get:
		return _disabled
	set(value):
		_disabled = value
		if is_instance_valid(GameManager) and _oview:
			_on_mouse_exited()
			_oview.modulate = Color.WHITE/2 if disabled else Color.WHITE
			
var default_color:Color

func _ready():
	if override_view == null: _oview = self
	else: _oview = override_view
	default_color = _oview.self_modulate
	if is_instance_valid(GameManager):
		_oview.modulate = Color.WHITE/2 if disabled else Color.WHITE
	super._ready()

func _on_mouse_entered():
	if disabled: return
	super._on_mouse_entered()
	_oview.self_modulate = (default_color + Color.BLACK)/2
	
func _on_mouse_exited():
	if disabled: return
	super._on_mouse_exited()
	_oview.self_modulate =default_color
	
func set_text(value:String):
	_text = value
	if has_node("RichTextLabel"):
		$RichTextLabel.text = template.format([value])

func get_text():
	return _text

# Called when the node enters the scene tree for the first time.
	
