extends Node2D

# onready var Data = preload("res://data/Data.gd")
var blockClass = preload("res://blocks/Block.tscn")
var timer = null
var grid = null
var gift_type = null

func _ready():
	grid = get_node("/root/Grid")
	timer = get_node("Timer")
	timer.connect("timeout", self, "on_timeout")
	var _err = get_node("/root/OnGame").connect("on_end_game", self, "end")

func start(timeout):
	clear()
	timer.set_wait_time(timeout)
	timer.start()

func end():
	timer.stop()
	clear()

func clear():
	for elem in get_node("Blocks").get_children():
		elem.queue_free()

func on_timeout():
	if !grid.isEndGame():
		var data = grid.getRandomFreePosition()
		if data != null: 
			data.pos.y = 0
			grid.preview[data.side][data.pos.x] = true
			createBlock(data)
	else:
		get_parent().end()
		timer.stop()

func createBlock(data):
	var block = blockClass.instance()
	if gift_type != null:
		block.init(data, 'preview', gift_type)
		gift_type = null
	else:
		block.init(data, 'preview')
	get_node("Blocks").add_child(block)
