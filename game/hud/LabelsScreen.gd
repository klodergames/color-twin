extends ReferenceRect

func _ready():
	pass

func call(text):
	get_node("Label").set_text(text)
	get_node("AnimationPlayer").play("go")
