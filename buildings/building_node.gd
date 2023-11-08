class_name building_node

extends Node2D

var scaffolding = preload("res://buildings/scaffolding.tscn")

var construction_points_needed = 2
var construction_points_current = 0
var under_construction = false
var has_builder = false

func _ready():
	pass

func add_scaffolding():
	var new_scaffolding = scaffolding.instantiate()
	add_child(new_scaffolding)
	under_construction = true
	Game.buildngs_construction_add(self)

func add_construction_points():
	construction_points_current += 1
	if construction_points_current >= construction_points_needed:
		add_building()

func add_building():
	pass
