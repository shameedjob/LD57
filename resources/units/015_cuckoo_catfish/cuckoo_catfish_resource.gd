extends AttackCrewResource

func try_attack():
	if get_chance() and CombatManager.instance.get_opponent(controller).crew.size()<4:
		await attack()
		
func do_attack():
	if CombatManager.instance.get_opponent(controller).crew.size()>=4:
		return
		
	if controller == CombatManager.instance.player_controller:
		var copy = self.duplicate()
		PlayerController.instance.active_crew.erase(self)
		PlayerController.instance.inventory_crew.append(copy)
	controller.crew.erase(instance)
	CombatManager.instance.get_opponent(controller).add_crew(self)
