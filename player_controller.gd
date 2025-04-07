class_name PlayerController
extends Node

static var instance:PlayerController
@export var bucks = 10

var active_crew:Array[CrewResource]
var inventory_crew:Array[CrewResource]

func _ready() -> void:
	instance = self

func crew_size():
	return active_crew.size() + inventory_crew.size()

func change_bucks(amt):
	bucks += amt
	GameManager.battle_window.get_node("PlayerGameUI/ExtraView/BuckText").text = "[font_size=24]$"+str(bucks)
	
func update_crew():
	GameManager.battle_window.get_node("PlayerGameUI/ExtraView/CrewText").text = "[font_size=24]Crew: "+str(crew_size())

func win_experience():
	for c in active_crew:
		c.gain_exp()
func kill_off(crew:CrewResource):
	await crew.on_eat()
	if crew in active_crew:
		active_crew.erase(crew)
	if crew in inventory_crew:
		inventory_crew.erase(crew)
	if crew_size() == 0:
		GameManager.game_loss()
		return true
	return false
