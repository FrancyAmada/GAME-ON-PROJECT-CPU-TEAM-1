extends HitBoxComponent

class_name HitBoxComponent_archer

func receive_hit(damage: float, knockback: Vector2):
	emit_signal("on_hit", knockback)
