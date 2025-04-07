class_name EffectManager

static func create_effect(effect_name, parent):
	var effect = load(effect_name).instantiate()
	var sub = SubControlNode.get_sub_node(effect, EffectControlSub)
	return sub.load_effect(parent)
