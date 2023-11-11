extends Node2D


@export var timer: Timer

var TIME_CYCLE = 100
var TIME_TRANSITION = 20
var count: int = 0

@onready var day_light: DirectionalLight2D = $Day
@onready var night_light: DirectionalLight2D = $Night

func _ready():
	timer.connect("timeout", _on_day_night_timeout)

func _on_day_night_timeout():
	change_time()
#	print_debug("Day: ", DayNight.is_day, " Time: ", str(count))
	if count >= TIME_CYCLE: 
		day_light.change_time(DayNight.is_day)
		night_light.change_time(DayNight.is_day)
		DayNight.transitioning_phase = true
		
	timer.start()
	count += 1


func change_time():
	var stop_count = TIME_CYCLE + TIME_TRANSITION
	if count == stop_count:
		DayNight.transitioning_phase = false
		DayNight.is_day = not DayNight.is_day
		count = 0
		DayNight.day_count += 1
