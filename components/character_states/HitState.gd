extends State

class_name HitState

@export var health_component: HealthComponent
@export var hitbox_component: HitBoxComponent
@export var dead_state: State
@export var return_animation_name: String = "Move"
@export var hit_animation_node: String = "Hit"
@export var return_state: State

@onready var timer: Timer = $Timer

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
	if health_component.health > 0:
		character.velocity = knockback
		emit_signal("interrupt_state", self)
	else:
		emit_signal("interrupt_state", dead_state)

func _on_timer_timeout():
	next_state = return_state
	playback.travel(return_animation_name)
	character.velocity = Vector2.ZERO
