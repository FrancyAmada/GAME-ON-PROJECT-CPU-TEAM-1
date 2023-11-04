extends Node2D

class_name PlayerDetectionComponent

signal chase_player(body: CharacterBody2D)

@export var detection_area: Area2D

@onready var character: CharacterBody2D = get_parent()


func _ready():
	detection_area.connect("_on_body_entered", _on_player_detection_body_entered)
	detection_area.connect("_on_body_exited", _on_player_detection_body_exited)
 
func start_chase(body: CharacterBody2D):
	emit_signal("chase_player", body)
	
func stop_chase():
	emit_signal("chase_player", null)

func _on_player_detection_body_entered(body):
	for child in body.get_children():
		if child is HitBoxComponent:
			start_chase(body)
			
func _on_player_detection_body_exited(body):
	for child in body.get_children():
		if child is HitBoxComponent:
			stop_chase()
