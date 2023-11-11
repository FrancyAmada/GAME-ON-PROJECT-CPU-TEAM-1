extends Control

class_name Transitioner

@export var scene_to_load: PackedScene

@onready var texture_rect: TextureRect = $TextureRect
@onready var text_rect: TextureRect = $Gameover_text
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	texture_rect.visible = false
	text_rect.visible = false
		
func activate_transition():
	animation_player.queue("fade_out")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_packed(scene_to_load)
