extends DirectionalLight2D


func change_time(is_day: bool):
	if is_day:
		energy += 0.015
	else:
		energy -= 0.015
	print_debug("Night Energy: ", str(energy))
