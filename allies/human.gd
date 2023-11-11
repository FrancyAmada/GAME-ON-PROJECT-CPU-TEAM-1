extends Node2D

var homeless_role = preload("res://allies/homeless/homeless.tscn")
var jobless_role = preload("res://allies/jobless/jobless.tscn")
var archer_role = preload("res://allies/archer_2/archer.tscn")
var builder_role = preload("res://allies/builder_2/builder.tscn")
@onready var homeless = $homeless as Homeless

var position_at : Vector2

func _ready():
	homeless.connect("to_jobless", change_to_jobless)

func _physics_process(delta):
	if get_child_count() > 0:
		position_at = get_child(0).global_position

func change_to_jobless():
	for child in get_children():
		child.queue_free()
	
	var new_jobless = jobless_role.instantiate()
	add_child(new_jobless)
#	print_debug(position_at)
	new_jobless.global_position = position_at
	new_jobless.connect("to_builder", change_to_builder)
	new_jobless.connect("to_archer", change_to_archer)

func change_to_homeless():
	for child in get_children():
		child.queue_free()
	
	var new_homeless = homeless_role.instantiate()
	add_child(new_homeless)
	new_homeless.global_position = position_at

func change_to_builder():
	for child in get_children():
		child.queue_free()
	
	var new_builder = builder_role.instantiate()
	add_child(new_builder)
	new_builder.global_position = position_at

func change_to_archer():
	for child in get_children():
		child.queue_free()
	
	var new_archer = archer_role.instantiate()
	add_child(new_archer)
	new_archer.global_position = position_at
