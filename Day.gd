extends DirectionalLight2D


func change_time(is_day: bool):
	if is_day:
		energy -= 0.045
	else:
		energy += 0.045
#	print_debug("Day Energy: ", str(energy))
