extends Node2D

onready var touchArray = preload("res://data/TouchArray.gd").new()
signal path

var color = Color(1.0, 1.0, 1.0, .5)

func _ready():
	var _err = $"/root/OnGame".connect("on_end_game", self, "stop")
	_err = $"/root/OnGame".connect("on_start_game", self, "start")

func start():
	set_process(true)
	set_process_input(true)
	touchArray.clear()
	show()

func stop():
	set_process(false)
	set_process_input(false)
	touchArray.clear()
	hide()

func _draw():
	for touch in touchArray.getAll():
		if touch['points'].size() > 1:
			var first = true
			var before_point = null
			for point in touch['points']:
				if !first:
					draw_line(before_point, point, color, 12)
				else:
					first = false
				before_point = point
				# draw_circle(point, 6.0, color)

func _process(_delta):
    update()

func _input(ev):
	if ev is InputEventScreenTouch:
		if ev.pressed:
			touchArray.add(ev.index)
		else:
			var touch = touchArray.get(ev.index)
			if touch == null: return
			if touch['points'].size() > 1: emit_signal("path", touch['points'])
			touchArray.remove(ev.index)
	if ev is InputEventScreenDrag && touchArray.has(ev.index):
		var touch = touchArray.get(ev.index)
		touch['points'].append(ev.position)

