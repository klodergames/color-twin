extends Node
class_name MenuAnimation

var tween
var items:Array = []
var delay:int = 0
var _err

func _ready():
	tween = Tween.new()
	add_child(tween)

func init(items:Array, delay:int = 0):
	self.items = items
	self.delay = delay

# On animation
func on():
	reset()
	var d = 0
	var speed = 1
	for item in items:
		_err = tween.interpolate_property(item, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), speed, Tween.TRANS_BOUNCE, Tween.EASE_IN, d)
		_err = tween.interpolate_property(item, "modulate", Color(1, 1, 1, .5), Color(1, 1, 1, 1), speed, Tween.TRANS_BOUNCE, Tween.EASE_IN, d + .7)
		d += delay
	tween.start()
	return d

# Off animation
func off():
	var d = 0
	var speed = .3
	for item in items:
		_err = tween.interpolate_property(item, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), speed, Tween.TRANS_CUBIC, Tween.EASE_IN, d)
		d += delay
	tween.start()
	return d

func reset():
	for item in items:
		item.modulate.a = 0
