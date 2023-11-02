extends Node2D

var House = preload("res://props/house.tscn")

func _process(delta):
	var lamp = 0
	for child in get_children():
		if child.is_in_group("interactable"):
			lamp += 1
	if lamp < 1:
		var new_house = House.instantiate()
		add_child(new_house)
