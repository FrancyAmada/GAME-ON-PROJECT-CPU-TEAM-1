extends ParallaxLayer

class_name BGLayer

var layers: Array[Sprite2D]


func _ready():
	for child in get_children():
		layers.append(child)

func change_alpha(is_day: bool):
	for layer in layers:
		if is_day:
			layer.modulate.r -= 0.04
			layer.modulate.g -= 0.04
			layer.modulate.b -= 0.04
		else: 
			layer.modulate.r += 0.04
			layer.modulate.g += 0.04
			layer.modulate.b += 0.04
