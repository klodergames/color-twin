extends Node2D

var _err

var colors = ["#FF0092", "#228DFF", "#FFCA1B", "#B6FF00", "#BB00F9"]

func row(color, rot, data):
	var c = Color(colors[color])
	$Sprite.set_modulate(c)
	rotation = rot
	
	var dir = Vector2(0, 1).rotated(-rot)
	var pos = Vector2()
	var t = .15
	if dir.x == -1:
		pos.x = -45 * (data.pos.x)
		t = data.pos.x * t
	elif dir.x == 1:
		pos.x = 45 * (5 - data.pos.x)
		t = (5 - data.pos.x) * t
	elif dir.y == -1:
		pos.y = 45 * (data.pos.y)
		t = data.pos.y * t
	elif dir.y == 1:
		pos.y = -45 * (5 - data.pos.y)
		t = (5 - data.pos.y) * t
	
	var newPos = position + pos
	if newPos == position: queue_free()
	
	$Tween.interpolate_property(self, "position", position, newPos, t, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), t, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_err = $Tween.connect("tween_completed", self, "on_tween_completed")
	$Tween.start()

func on_tween_completed(_object, _key):
	queue_free()