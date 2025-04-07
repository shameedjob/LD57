extends Control
@onready var win_text:RichTextLabel= $WinText
@onready var lose_text:RichTextLabel= $LoseText
@onready var enemy_game_ui = $EnemyGameUI
@onready var player_game_ui = $PlayerGameUI
@onready var depth_window = $DepthWindow

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
