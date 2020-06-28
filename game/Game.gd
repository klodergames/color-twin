extends Node2D

onready var LevelFactory = preload("res://data/LevelFactory.gd").new()
var level = 1

func _ready():
	get_node("/root/Music").playAgainSam()
	var _err = $Draw.connect("path", self, "on_path")
	_err = get_node("/root/OnGame").connect("on_end_game", self, "on_end_game")
	_err = get_node("/root/OnGame").connect("on_vs_delete", self, "on_vs_delete")
	_err = get_node("/root/OnGame").connect("on_vs_gift", self, "on_vs_gift")
	level = get_node("/root/OnGame").level
	start()

func retry():
	start()

func next():
	level += 1
	get_node("/root/OnGame").level += 1
	start()
	
	if get_node("/root/OnGame").multiplayer:
		get_node("/root/GooglePlayGameServices").sendBroadcastMessage("level_up")

func on_path(path):
	get_node("VisualGrid").on_path(path)

func start():
	get_node("/root/Music").playHight()
	var levelData = LevelFactory.getLevel(level)
	get_node("Hud").start(level, levelData)
	get_node("VisualGrid").start(levelData)
	get_node("Preview").start(levelData['speed'])
	get_node("/root/OnGame").start(levelData)
	get_node("/root/SaveGame").saveGame()

func end():
	get_node("Draw").stop()
	get_node("Hud/GameOverScreen").start()

func on_end_game():
	get_node("/root/Music").playLowPlease()

func on_vs_delete(counter):
	if counter == 6:
		var blocks = get_node("/root/Grid").get_filtered_blocks('bomb')
		if blocks.size() > 0:
			var block = blocks[randi() % blocks.size()]
			block.remove_effect()
			get_node("/root/GooglePlayGameServices").sendBroadcastMessage("g.2")
			get_node("Hud/VSLabelsScreen").call("stolen bomb")
		else:
			counter = 5
	if counter == 5:
		var blocks = get_node("/root/Grid").get_filtered_blocks('row')
		if blocks.size() > 0:
			var block = blocks[randi() % blocks.size()]
			block.remove_effect()
			get_node("/root/GooglePlayGameServices").sendBroadcastMessage("g.1")
			get_node("Hud/VSLabelsScreen").call("stolen row effect")
		else:
			counter = 4
	if counter == 4:
		get_node("/root/Grid").add_flash_block()
		if get_node("/root/Music").sfx:
			get_node("VisualGrid/SamplePlayer2D").play('fail')
		get_node("Hud/VSLabelsScreen").call("block added")

func on_vs_gift(gift_type):
	var blocks = get_node("/root/Grid").get_filtered_blocks('color')
	if blocks.size > 0:
		var block = blocks[randi() % blocks.size()]
		block.remove_effect(gift_type)
	else:
		get_node("Preview").gift_type = gift_type
	get_node("Hud/VSLabelsScreen").call("gift %s" % gift_type)

func _on_Timer_timeout():
	#on_vs_delete(4)
	# get_node("/root/Grid").shuffle()
	pass
	


func _on_Draw_path():
	pass # Replace with function body.
