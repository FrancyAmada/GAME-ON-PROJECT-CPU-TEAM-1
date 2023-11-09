extends HitState

class_name HitState_archer
@onready var archer = $"../.." as archer

signal dropBow

func _ready():
	hitbox_component.connect("on_hit", _on_hit_box_component_on_hit)
	
func on_enter():
	timer.start()
	playback.travel(hit_animation_node)
	
func on_exit():
	next_state = return_state
	playback.travel(return_animation_name)
	character.velocity = Vector2.ZERO

func _on_hit_box_component_on_hit(knockback: Vector2):
	print("hit!")
	character.velocity = knockback
	dropBow.emit()

func _on_timer_timeout():
	next_state = return_state
	playback.travel(return_animation_name)
	character.velocity = Vector2.ZERO
