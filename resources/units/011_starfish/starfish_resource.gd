extends CrewResource

func on_start():
	for c in controller.crew:
		if c.resource == self:
			continue
		if c.resource.get_stat("chance_h"):
			c.resource.change_stat("chance_h", c.resource.get_stat("chance_h") + get_stat("chance_h"))
		if c.resource.get_stat("chance_t"):
			c.resource.change_stat("chance_t", c.resource.get_stat("chance_t") + get_stat("chance_t"))
	pass
