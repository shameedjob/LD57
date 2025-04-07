extends NinePatchRect
@onready var msg_label:RichTextLabel = $RichTextLabel
@export var offset = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	msg_label.resized.connect(m_size_flag_changed)
	msg_label.finished.connect(m_size_flag_changed)
	pass # Replace with function body.

func m_size_flag_changed():
	size = Vector2(size.x, msg_label.size.y+offset)

func _process(delta):
	if size != Vector2(size.x, msg_label.size.y+offset):
		m_size_flag_changed()
	pass
