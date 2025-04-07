extends Control

var model:Node3D 
var cube_material:Material
var text_container:Control
var text:RichTextLabel
var audio_controller:AudioStreamPlayer
@export var base_texture:Texture2D
@export var talking_texture:Array[Texture2D]



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cube_material= $SubViewport/beffrey/Cube.material_override
	model = $SubViewport/beffrey
	audio_controller = $AudioStreamPlayer
	text = $View/TextContainer/RichTextLabel
	text_container = $View/TextContainer
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_look()
	pass

func mouse_look():
	var dir = (($View.global_position+$View.size/2)-get_global_mouse_position())/64
	model.look_at(Vector3(dir.x, -dir.y, -10))
func talk_update():
	set_texture(talking_texture.pick_random())
	
func set_texture(texture:Texture2D):
	cube_material.albedo_texture = texture
	
func speak(dialogue:Array):
	text_container.visible = true
	var script = {
		"text": dialogue,
		"template": "[font_size=16][color=black]"
	}
	await DialogueHelper.speak(script ,text, audio_controller, talk_update)
	text_container.visible = false
	set_texture(base_texture)

func intro_tutorial():
	var tutorial_text = [
		"Hello human! My name is Beffrey",
		"I've come to your planet becaause I've heard of an exciting adventure!",
		"Long ago, a massive ship called the TITANIC sunk in the ocean!",
		"Together, you can take me to this miracle!"
	]
	await speak(tutorial_text)
	var text = [
		"You must prove that you're worthy to take me though!",
		"Create a crew and defeat every other opponent and I will join you.",
	]
	await speak(text)

func game_loss():
	var text = [
		"OOF, sorry about that loss friend",
		"Maybe next time you'll be able to win!"
	]
	await  speak(text)
	
func game_win():
	var text = [
		"Congratulations, human! Your crew is the last one remaining",
		"You may now do the honors of taking me on your vessel to explore the deep blue.",
		"I hope every one of your opponents can feel pride that they lost to you!",
		"... huh? Where is everyone...",
		"Wait... you're telling me that all of your opponents exploded?!?",
	]
	await  speak(text)
	text = [
		"Yeah, on second thought.",
		"Maybe people shouldn't be diving in the ocean.",
		"Especially not in makeshift crucibles like this...",
		"I'm leaving now... have a great life, I guess!",
		"Good bye"
	]
	await speak(text)
