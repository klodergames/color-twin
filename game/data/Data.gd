# This class is for contain
# a) Position in grid
# b) Side: left or right

extends Node

var center = 320
var scale = Vector2(45, -45)
var offset = { 'left': Vector2(45, 590/2), 'right': Vector2(740/2, 590/2) }

var pos = Vector2()
var side = 'left'

func _init(pos = Vector2(), side = 'left'):
	self.pos = pos
	self.side = side

func getPos():
	return offset[side] + (pos * scale)

func getPreviewPos():
	return Vector2(getPos().x, 45)

func parse(point):
	if point.x <= center: side = 'left'
	else: side = 'right'
	pos = ((point - offset[side]) / scale)
	rounded()

func rounded():
	pos.x = round(pos.x)
	pos.y = round(pos.y)

func clone():
	return get_script().new(Vector2(pos.x, pos.y), side)