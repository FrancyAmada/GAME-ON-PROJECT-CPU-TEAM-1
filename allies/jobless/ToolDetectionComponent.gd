extends Node2D

class_name ToolDetectionComponent

signal chase_tool(body: RigidBody2D)

@onready var detection_area: Area2D = $ToolDetection
@onready var character: CharacterBody2D = get_parent()

var tool_list: Array

var target_tool: RigidBody2D
var tool_distance: int

func _ready():
	Signals.connect("tool_collected", _on_tool_collected_signal)
	detection_area.connect("_on_body_entered", _on_tool_detection_body_entered)
	detection_area.connect("_on_body_exited", _on_tool_detection_body_exited) 

func _physics_process(delta):
	tool_distance = 600
	target_tool = null
	var distance: int
	
	for tool in tool_list:
		distance = abs(character.global_position.x - tool.global_position.x)
		if distance < tool_distance:
			tool_distance = distance
			target_tool = tool
		
	if len(tool_list) != 0:
		start_chase(target_tool)
	else:
		tool_distance = 600
		target_tool = null
		stop_chase()
	
func start_chase(body: RigidBody2D):
	emit_signal("chase_tool", body)
	
func stop_chase():
	emit_signal("chase_tool", null)

func _on_tool_detection_body_entered(body):
#	print_debug(body)
	if body.is_in_group("tool"):
		print("a tool!")
		tool_list.append(body)
	
func _on_tool_detection_body_exited(body):
	if body in tool_list:
		tool_list.erase(body)
		
	if len(tool_list) == 0:
		stop_chase()
		tool_distance = 600

func _on_tool_collected_signal(tool: Node):
	if tool in tool_list:
		tool_list.erase(tool)

func get_tool():
	if len(tool_list) == 0:
		target_tool = null
		tool_distance = 600
	else:
		target_tool = tool_list[0]
	return [target_tool, tool_distance]
