extends RigidBody2D

class_name despawnable_object

var despawn_time = 3
var time_elapsed = 0

func _physics_process(delta):
	time_elapsed += delta
	
	if time_elapsed >= despawn_time:
		queue_free()
