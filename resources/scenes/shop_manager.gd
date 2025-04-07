class_name ShopManager
extends Node

var inv_item = preload("res://resources/scenes/inventory_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func load_items():
	for c in $Crew.get_children():
		c.queue_free()
	load_shop()
	load_can()
	load_box()
	update_go_button()
	pass # Replace with function body.

func load_shop():
	var choices = get_shop_choices()
	for i in 5:
		var item = load_item(choices.pick_random().duplicate())
		item.change_state($ShopArea2D.global_position, false, false)
		item.go_to_position()
		
func load_item(i:CrewResource)->InventoryItemObject:
	var item:InventoryItemObject = inv_item.instantiate()
	$Crew.add_child(item)
	item.load_item(i)
	item.s_buy.connect(buy)
	item.s_add_active.connect(add_active)
	item.s_sell.connect(sell)
	item.s_add_crew.connect(add_crew)
	return item
	
	
func load_box():
	for i in PlayerController.instance.inventory_crew:
		add_inventory_ui(i)
		
func load_can():
	for i in PlayerController.instance.active_crew:
		add_active_ui(i)
		
func add_inventory_ui(i):
	var item = load_item(i)
	item.change_state($CrewArea.global_position, true, false)
	item.go_to_position()
	update_go_button()
	pass

func add_active_ui(i):
	var item = load_item(i)
	item.change_state($Can/CanArea.global_position, true, true)
	item.go_to_position()
	update_go_button()
	pass
	
func buy(node):
	if PlayerController.instance.bucks >= 3:
		PlayerController.instance.change_bucks(-3)
		if over == MOUSE_OVER.CAN and PlayerController.instance.active_crew.size() < 4:
			node.change_state($Can/CanArea.global_position, true, true)
			PlayerController.instance.active_crew.append(node.item)
		else:
			node.change_state($CrewArea.global_position, true, false)
			if over == MOUSE_OVER.CAN:
				node.go_to_position()
			PlayerController.instance.inventory_crew.append(node.item)
		PlayerController.instance.update_crew()
	else:
		node.go_to_position()
	update_go_button()

func add_active(node):
	if PlayerController.instance.active_crew.size()< 4 and not node.active:
		node.change_state($Can/CanArea.global_position, true, true)
		PlayerController.instance.inventory_crew.erase(node.item)
		PlayerController.instance.active_crew.append(node.item)
	else: node.go_to_position()
	update_go_button()

func add_crew(node):
	if node.active:
		node.change_state($CrewArea.global_position, true, false)
		PlayerController.instance.active_crew.erase(node.item)
		PlayerController.instance.inventory_crew.append(node.item)
	update_go_button()
	pass

func hide():
	for c in get_children():
		c.visible = false
	

func show():
	for c in get_children():
		c.visible = true

func unload():
	for c in $CanvasLayer/HBoxContainer/ShopPanel/VBoxContainer.get_children():
		c.queue_free()
	for c in $CanvasLayer/HBoxContainer/BoxPanel/VBoxContainer.get_children():
		c.queue_free()
	for c in $CanvasLayer/HBoxContainer/CanPanel/VBoxContainer.get_children():
		c.queue_free()

func sell(node):
	if PlayerController.instance.active_crew.size() + PlayerController.instance.inventory_crew.size() <= 1:
		node.go_to_position()
		update_go_button()
		return
		
	PlayerController.instance.change_bucks(1)
	if node.item in PlayerController.instance.active_crew:
		PlayerController.instance.active_crew.erase(node.item)
	elif node.item in PlayerController.instance.inventory_crew:
		PlayerController.instance.inventory_crew.erase(node.item)
	PlayerController.instance.update_crew()
	node.queue_free()
	update_go_button()
	
	
func get_shop_choices():
	var choices = []
	for c in GameManager.all_crew:
		if (c.tier-1)*2 <= min(8, GameManager.c_round):
			choices.append(c)
	return choices

func update_go_button():
	$CanvasLayer/GoButton.disabled =  PlayerController.instance.active_crew.size() <= 0

func _on_go_button_click() -> void:
	GameManager.go_to_combat()
	pass # Replace with function body.

enum MOUSE_OVER{ CAN, CREW, SHOP, NONE}
var over:MOUSE_OVER = MOUSE_OVER.NONE

func can_enter():
	over = MOUSE_OVER.CAN
	pass
	
func can_exit():
	over = MOUSE_OVER.NONE
	pass
	
func crew_enter():
	over = MOUSE_OVER.CREW
	pass
	
func crew_exit():
	over = MOUSE_OVER.NONE
	pass

func shop_enter():
	over = MOUSE_OVER.SHOP
	pass
	
func shop_exit():
	over = MOUSE_OVER.NONE
	pass
