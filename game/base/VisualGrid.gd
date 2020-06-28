extends Node2D

onready var serie = preload("res://data/Serie.gd").new()
onready var Data = preload("res://data/Data.gd")
var blockClass = preload("res://blocks/Block.tscn")
var grid = null

# Sounds
var failSound
var successSound

var level = {}

func _ready():
	setupSFX()
	grid = $"/root/Grid"
	# set_process(true) # for debug

func setupSFX():
	failSound = AudioStreamPlayer.new()
	successSound = AudioStreamPlayer.new()
	self.add_child(failSound)
	self.add_child(successSound)
	failSound.stream = load("res://sfx/fail.wav")
	successSound.stream = load("res://sfx/success.wav")

func start(level):
	grid.init()
	clear()
	self.level = level
	fillGrid()

func clear():
	for elem in get_node("Blocks").get_children():
		elem.queue_free()

func createBlock(data, type = 'color'):
	if data == null: return
	var block = blockClass.instance()
	block.init(data, 'direct', type)
	get_node("Blocks").add_child(block)

func fillGrid():
	for side in ['left', 'right']:
		var height = 6
		if level[side].has("height"): height = level[side]["height"]
		if level[side].has("fix"):
			for fixBlock in level[side]['fix']:
				createBlock(Data.new(Vector2(fixBlock.x, fixBlock.y), side), 'fixed')
		if level[side].has("blocks"):
			while level[side]['blocks'] > 0:
				createBlock(grid.getSideRandomFreePosition(side, height))
				level[side]['blocks'] -= 1

func on_path(path):
	serie.clear()
	for data in getGridsItem(path):
		serie.add(grid.getBlock(data))
	serie.doAction(grid)
	if $"/root/Music".sfx:
		if serie.action == "success":
			successSound.play()
		elif serie.action == "fail":
			failSound.play()

func getGridsItem(path):
	var points = []
	for point in path:
		var data = Data.new()
		data.parse(point)
		points.append(data)
	return points

func _process(_delta):
	debug()

func debug():
	for side in grid.grid:
		var text = ''
		for i in range(6):
			var line = ''
			for j in range(6):
				if grid.grid[side][j][5-i] == null: line += '0, '
				else: line += '1, '
			text += line + "\n"
		get_node("debug/" + side).set_text(text)