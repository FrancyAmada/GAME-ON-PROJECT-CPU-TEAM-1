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
	print("test")
	for child in get_children():
		child.queue_free()
	
	var new_jobless = jobless_role.instantiate()
	add_child(new_jobless)
	print(position_at)
	new_jobless.global_position = position_at
