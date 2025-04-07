extends UIInteractableTextButton
var item:CrewResource
signal interact(node)
signal sell(node)
var active:bool = false

func load_item(crew:CrewResource, active:bool = false):
	text = crew.name
	item = crew
	self.active = active
	click.connect(on_click)
	r_click.connect(on_r_click)
	
func on_click():
	interact.emit(self)
	pass
	
func on_r_click():
	sell.emit(self)
	pass
