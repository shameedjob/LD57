class_name InventoryItemObject
extends RigidBody2D
var owned = false
var active = false
var item:CrewResource = null
var base_position:Vector2

func load_item(item):
	self.item = item
	$Sprite2D.texture = item.sprite
	$Sprite2D/EyeSprite.position = item.eye_pos
	pass
signal s_buy(node)
signal s_add_active(node)
signal s_add_crew(node)
signal s_sell(node)

func buy():
	s_buy.emit(self)

func sell():
	s_sell.emit(self)
	
func add_active():
	s_add_active.emit(self)
	
func add_crew():
	s_add_crew.emit(self)
	
func return_to_base():
	global_position = base_position

var setup = false
func change_state(_base_position = Vector2.ZERO, _owned = false, _active = false):
	if setup:
		position = get_global_mouse_position()
		linear_velocity = Vector2.ZERO
	setup = true
	self.owned = _owned
	self.active = _active
	self.base_position = _base_position

var area_entered = false
var dragging = false

func _on_select_area_entered() -> void:
	area_entered = true
	pass # Replace with function body.


func _on_select_area_exited() -> void:
	area_entered = false
	pass # Replace with function body.
	
func go_to_position():
	linear_velocity = (Vector2.RIGHT*500).rotated(2*PI*randf())
	global_position = base_position
	
func _process(delta: float) -> void:
	var n_area_entered = get_global_mouse_position().distance_to(global_position) < 40
	if n_area_entered != area_entered:
		area_entered = n_area_entered
		if area_entered:
			$SelectArea.emit_signal("mouse_entered")
		else:
			$SelectArea.emit_signal("mouse_exited")
	
	if area_entered and Input.is_action_just_pressed("left_mouse"):
		dragging = true
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		gravity_scale = 0.5
	if dragging == true and Input.is_action_just_released("left_mouse"):
		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		gravity_scale = 1
		dragging = false
		get_action()
		
	if area_entered and Input.is_action_just_pressed("right_mouse"):
		sell()
		
	if (abs(global_position.x) >1380/2 or abs(global_position.y) > 1060/2) and not dragging:
		go_to_position()
		pass

func get_action():
	if check_combine(): return
	
	match GameManager.shop.over:
		ShopManager.MOUSE_OVER.NONE:
			pass
		ShopManager.MOUSE_OVER.CREW:
			if active and owned: add_crew()
			elif not owned: buy()
			pass
		ShopManager.MOUSE_OVER.SHOP:
			if owned: sell()
			pass
		ShopManager.MOUSE_OVER.CAN:
			if not active and owned: add_active()
			elif not owned: buy()
			pass
	
func _physics_process(delta: float) -> void:
	if dragging:
		apply_force((get_global_mouse_position() - global_position)*20)

func get_custom_tooltip_text()->String:
	return item.tooltip_text()

func check_combine():
	if not owned:
		return false
	for c in GameManager.shop.get_node("Crew").get_children():

		if c.owned and c.area_entered and c.item != item and c.item.name == item.name:
			combine(c.item)
			return true
	return false
func combine(other:CrewResource):
	for l in (1+(1-item.level)*2+item.experience):
		other.gain_exp()
	if item in PlayerController.instance.active_crew:
		PlayerController.instance.active_crew.erase(item)
	elif item in PlayerController.instance.inventory_crew:
		PlayerController.instance.inventory_crew.erase(item)
	queue_free()
	PlayerController.instance.update_crew()
