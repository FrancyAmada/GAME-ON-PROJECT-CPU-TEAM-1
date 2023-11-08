extends Node

var player_gold = 0

var player_position = Vector2()

var buildings_construction: Array[building_node] = []

var city_hall_level = 0

func set_player_position(pos):
	player_position = pos

func setGold(amount):
	player_gold = amount

func buildngs_construction_add(building : building_node):
	buildings_construction.append(building)

func buildngs_construction_remove(building: building_node):
	if building in buildings_construction:
		var index = buildings_construction.find(building)
		buildings_construction.remove_at(index)
