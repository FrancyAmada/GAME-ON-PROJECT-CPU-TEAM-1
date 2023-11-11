extends building_node

@onready var dirt_mound = $dirt_mound as interactable_object
var wall_level_1 = preload("res://buildings/ineractable/wall_level_1.tscn")
var dirt_mound_1 = preload("res://buildings/ineractable/dirt_mound.tscn")
var wall_level_2 = preload("res://buildings/ineractable/wall_level_2.tscn")
var wall_level_3 = preload("res://buildings/ineractable/wall_level_3.tscn")
var wall_level_4 = preload("res://buildings/ineractable/wall_level_4.tscn")
@onready var build_range = $build_area
var done = true
var level = 0

func _ready():
	dirt_mound.build_me.connect(add_scaffolding)

func add_scaffolding():
	has_builder = false
	construction_points_current = 0
	level += 1
	var new_scaffolding = scaffolding.instantiate()
	add_child(new_scaffolding)
	under_construction = true
	Game.buildngs_construction_add(self)
	done = false

func add_construction_points():
	construction_points_current += 1
	var progress = (construction_points_current * 5 / construction_points_needed)
	for child in get_children():
		if child.is_in_group("scaffolding"):
			child.set_progress(progress)

	if construction_points_current == construction_points_needed:
		add_building()
		for child in get_children():
			if child.is_in_group("scaffolding"):
				child.queue_free()

func add_building():
	done = true
	if level == 1:
		var new_wall = wall_level_1.instantiate()
		add_child(new_wall)
		new_wall.connect("build_me", add_scaffolding)
	elif level == 2:
		var new_wall = wall_level_2.instantiate()
		add_child(new_wall)
		new_wall.connect("build_me", add_scaffolding)
	elif level == 3:
		var new_wall = wall_level_3.instantiate()
		add_child(new_wall)
		new_wall.connect("build_me", add_scaffolding)
	elif level == 4:
		var new_wall = wall_level_4.instantiate()
		add_child(new_wall)
		new_wall.connect("build_me", add_scaffolding)
	
	Game.buildngs_construction_remove(self)
