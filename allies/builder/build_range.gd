extends Area2D


func _ready():
	monitoring = false
	get_parent().connect("start_check_for_building", _on_start_building)
	

func _on_start_building():
	monitoring = true
	
