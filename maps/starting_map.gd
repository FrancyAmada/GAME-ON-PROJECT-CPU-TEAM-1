extends Node2D

@onready var night_ambiance = $night_ambiance

func _process(delta):
	if !DayNight.is_day and !night_ambiance.is_playing():
		night_ambiance.play()
	elif DayNight.is_day:
		night_ambiance.stop()
