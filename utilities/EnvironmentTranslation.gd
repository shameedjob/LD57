extends Node


func v2_to_v3(point:Vector2)->Vector3:
	var max = get_viewport().get_visible_rect().size
	return Vector3(-(point.x-max.x/2) /64, -(point.y-max.y/2) /64, 0)
	
func v2_to_v3_sim(point:Vector2)->Vector3:
	var max = get_viewport().get_visible_rect().size
	return Vector3(-point.x/64, -point.y/64, 0)
	
func v3_to_v2_sim(point:Vector3)->Vector2:
	var max = get_viewport().get_visible_rect().size
	return Vector2(-point.x*64, -point.y*64)
func v3_to_v2(point:Vector3)->Vector2:
	var max = get_viewport().get_visible_rect().size
	return Vector2(-point.x*64 + max.x/2, -point.y*64 + max.y/2)
func v2_sim_to_v2(point:Vector2):
	var max = get_viewport().get_visible_rect().size
	return point + max/2
func v2_to_v2_sim(point:Vector2):
	var max = get_viewport().get_visible_rect().size
	return point - max/2
