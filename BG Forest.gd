extends ParallaxBackground

@export var timer: Timer

var scrolling_speed = 100
var parallax_layers: Array[ParallaxLayer]
var is_day: bool = true
var count: int = 0

func _process(delta):
	scroll_offset.x -= scrolling_speed * delta

func _ready():
	for child in get_children():
		parallax_layers.append(child)
