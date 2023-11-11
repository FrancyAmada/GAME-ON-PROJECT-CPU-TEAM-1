extends CharacterBody2D

class_name Builder

signal animation_is_finished(anim_name: String)

signal start_check_for_building

signal start_building

@export var hit_state: State
@export var build_state: State
@export var death_anim_name: String = "Death"

@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var enemydetection_component: EnemyDetectionComponent = $EnemyDetectionComponent
@onready var max_speed = velocity_component.max_speed
@onready var enemy: CharacterBody2D
@onready var build_range: Area2D = $Build_Range

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction: Vector2 = Vector2.ZERO

var go_to_building: bool = false
var building_to_construct : building_node = null
var building = false
var building_in_area : building_node = null

var enemy_distance: int = 600
var idle: bool = true
var run_away: bool = false
var idle_time: float = 0

var campfire_radius: int = 300


func _ready():
	build_state.connect("stop_building", _on_stop_building)
	
func _physics_process(delta):
	check_enemies()
	check_enemy_distance()
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if idle and !run_away:
		idle_time += delta
		get_idle_direction()
		velocity.x = direction.x * max_speed
	elif go_to_building and !run_away:
		get_direction_to_building()
		velocity.x = direction.x * max_speed
	elif enemy != null and state_machine.check_if_can_move():
		get_direction()
		velocity.x = direction.x * max_speed
	elif state_machine.current_state != hit_state and not idle:
		direction.x = 0
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	if building_to_construct:
		if building_to_construct.done:
			building_to_construct = null
			building_in_area = null
		elif building_in_area and building_to_construct and !building:
			await get_tree().create_timer(.2).timeout
			start_building.emit()
			building = true
			direction.x = 0
	else:
		find_buildings()
	
	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func get_idle_direction():
	if idle_time >= 2:
		var campfire: Campfire = get_node("/root/starting_map/Structures/campfire")
	#	print_debug(campfire)
		var distance_to_campfire: int = abs(global_position.x - campfire.global_position.x)
		
		if idle and distance_to_campfire <= campfire_radius:
			direction.x = randi_range(-1, 1)
		elif distance_to_campfire > campfire_radius:
			var direction_to_campfire: int = sign(campfire.global_position.x - global_position.x)
			direction.x = direction_to_campfire
#			print_debug(self, " going to campfire")
			
		idle_time = 0

func get_direction():
	if run_away:
		direction.x = -sign(enemy.global_position.x - global_position.x)
	
func check_enemy_distance():
	if enemy != null:
		if enemy_distance < 200:
			idle = false
			run_away = true
		elif run_away and enemy_distance > 300:
			idle = true
			run_away = false
			direction.x = 0
		
func find_buildings():
	var buildings_in_construction = Game.buildings_construction
	if buildings_in_construction.size() > 0:
		for child in buildings_in_construction:
			if !child.has_builder:
				# to ensure that the builder detects the building even when he is in the build area
				idle = false
				build_range.monitoring = false
				child.has_builder = true
				go_to_building = true
				building_to_construct = child
				start_check_for_building.emit()

func get_direction_to_building():
	if !building_in_area and building_to_construct and !building:
		if building_to_construct:
			direction.x = sign(building_to_construct.global_position.x - global_position.x)
		
func _on_build_range_area_entered(area):
	if building_to_construct:
		if area == building_to_construct.build_range:
			building_in_area = area.parent
			build_range.monitoring = false

func _on_stop_building():
	go_to_building = false
	building = false
	idle = true
	build_range.monitoring = false

func check_enemies():
	var enemy_data = enemydetection_component.get_enemy()
	enemy = enemy_data[0]
	enemy_distance = enemy_data[1]

