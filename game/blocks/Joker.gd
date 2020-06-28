extends Sprite

var tween

func _ready():
	tween = get_node("Tween")

func start():
	show()
	tween.interpolate_property(self, "visibility/opacity", 1, 0, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_complete", self, "on_tween_complete")
	tween.start()

func on_tween_complete():
	tween.disconnect("tween_complete", self, "on_tween_complete")
	hide()
