extends ParallaxBackground

@export var timer: Timer

var scrolling_speed = 100
var parallax_layers: Array[ParallaxLayer]
var is_day: bool = true
var count: int = 0

func _process(delta):
	scroll_offset.x -= scrolling_speed * delta

func _ready():
	timer.start()
	for child in get_children():
		parallax_layers.append(child)

func _on_day_night_timeout():
	change_time()
	for layer in parallax_layers:
		layer.change_alpha(is_day)
	timer.start()
	count += 1

func change_time():
	if count == 20:
		is_day = not is_day
		count = 0


