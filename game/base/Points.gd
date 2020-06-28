extends Node2D

func start(points, delay = 0):
	$Label.set_text(str(points))
	if delay == 0: anim()
	else:
		$Timer.set_wait_time(delay)
		var _err = $Timer.connect("timeout", self, "anim")
		$Timer.start()

func anim():
	$Label.show()
	$Tween.interpolate_property($Label, "rect_position", $Label.rect_position, $Label.rect_position - Vector2(0,45), .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.interpolate_property($Label, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	var _err = $Tween.connect("tween_completed", self, "finish")
	$Tween.start()

func finish(_object, _key):
	if $Tween.is_connected("tween_completed", self, "finish"):
		$Tween.disconnect("tween_completed", self, "finish")
	queue_free()
