class_name AttackCrewResource
extends CrewResource

@export var damage = 1
@export var chance_h:int = 1
@export var chance_t:int = 1

func on_turn_pass():
	await try_attack()
	
func try_attack():
	if randi_range(0,  get_stat("chance_t"))<= get_stat("chance_h"):
		await attack()

func attack():
	await instance.attack_effect()
	await controller.attack_effect()
	
	await do_attack()
	
func do_attack():
	await CombatManager.instance.get_opponent(controller).change_oxygen(-get_stat("damage"))
