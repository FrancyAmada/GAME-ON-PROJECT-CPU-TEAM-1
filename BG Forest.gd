extends ParallaxBackground

@export var timer: Timer

var TIME_CYCLE = 100
var TIME_TRANSITION = 20
var scrolling_speed = 100
var parallax_layers: Array[ParallaxLayer]
var count: int = 0

func _process(delta):
	scroll_offset.x -= scrolling_speed * delta

func _ready():
	for child in get_children():
		parallax_layers.append(child)

func _on_day_night_timeout():
	change_time()
#	print_debug("Day: ", DayNight.is_day, " Time: ", str(count))
	if count >= TIME_CYCLE: 
		for layer in parallax_layers:
			layer.change_alpha(DayNight.is_day)
	count += 1

func change_time():
	var stop_count = TIME_CYCLE + TIME_TRANSITION
	if count == stop_count:
		count = 0
