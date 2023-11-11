extends Node2D

func _on_button_pressed():
	print("i am pressed!")
	get_tree().change_scene_to_file("res://maps/starting_map.tscn")
