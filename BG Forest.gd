extends ParallaxBackground

@export var timer: Timer

var TIME_CYCLE = 120
var TIME_TRANSITION = 25
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
	if count >= TIME_CYCLE: 
		for layer in parallax_layers:
			layer.change_alpha(is_day)
	timer.start()
	count += 1

func change_time():
	var stop_count = TIME_CYCLE + TIME_TRANSITION
	if count == stop_count:
		is_day = not is_day
		count = 0


