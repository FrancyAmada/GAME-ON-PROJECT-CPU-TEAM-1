extends MarginContainer

@onready var label = $MarginContainer/Label

const maxWidth = 256
var text = ""

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func set_text(new_text):
	text = new_text
