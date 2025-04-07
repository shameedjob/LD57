extends UIInteractableTextButton
var item:CrewResource
signal purchase(node)

func load_item(crew:CrewResource):
	text = crew.name
	item = crew
	click.connect(on_click)
		
func on_click():
	purchase.emit(self)
	pass
