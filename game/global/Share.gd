extends Node

var lib

func _ready():
	if Engine.has_singleton("GodotShare"):
		lib = Engine.get_singleton("GodotShare")

func share(text):
	if lib != null:
		lib.share("Color Twin", text)