class_name ParticleEffectControlSub
extends EffectControlSub

func load_effect(caller):
	caller.get_parent().add_child(parent)
	parent.emitting = true
	return parent
