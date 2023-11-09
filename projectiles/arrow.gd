extends Area2D

class_name Arrow

@export var damage: float = 20.0

var speed = 500
var angle = 80
var velocity = Vector2()

var moving = true

func _ready():
	angle *= -1
	var angle_rad = deg2rad(angle)
	velocity = Vector2(cos(angle_rad), sin(angle_rad)) * speed
	rotation = angle
	monitoring = true

func deg2rad(deg):
	return deg * PI / 180

func _physics_process(delta):
	if moving:
		velocity.y += gravity * delta
		position += velocity * delta
		angle = velocity.angle()
		rotation = angle
#	print(gravity)

func _on_body_entered(body):
	if body.is_in_group("ground"):
		moving = false
#		print("start")
		velocity = Vector2(0, 0)
		
		await get_tree().create_timer(.2).timeout
		queue_free()
		
	if body.is_in_group("enemy"):
		var hitbox: HitBoxComponent = body.find_child("HitBoxComponent")
		var knockback: Vector2 = Vector2(sign(velocity.x) * 150, -30)
		if hitbox:
			hitbox.receive_hit(damage, knockback)
			queue_free()
	
	if body.is_in_group("animals"):
		body.get_hit(damage)
		queue_free()
