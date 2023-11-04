extends Node2D

class_name HitBoxComponent

signal on_hit(knockback: Vector2)

@export var health_component: HealthComponent
@export var area: CollisionShape2D
@export var hit_state: HitState


func receive_hit(damage: float, knockback: Vector2):
	health_component.health -= damage
	
	emit_signal("on_hit", knockback)
	
