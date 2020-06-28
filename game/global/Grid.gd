extends Node

var Data = preload("res://data/Data.gd")
var SuccessArray = preload("res://data/SuccessArray.gd")
var blockClass = preload("res://blocks/Block.tscn")
var Shuffle = preload("res://data/Shuffle.gd")

var grid = { "left": [], "right": [] }
var preview = { "left": [], "right": [] }
var offset = { 'left': Vector2(45, 590/2), 'right': Vector2(740/2, 590/2) }

func _ready():
	init()

func init():
	for side in grid:
		grid[side] = []
		for _i in range(6):
			grid[side].append([null, null, null, null, null, null])
	for side in preview:
		preview[side] = [false, false, false, false, false, false]

func removeBlock(data):
	grid[data.side][data.pos.x][data.pos.y] = null
	checkColumnGravity(data.side, data.pos.x)

func getColor(data):
	var block = getBlock(data)
	if block == null: return null
	return block.color

func getBlock(data):
	if data.pos.x >= 6 or data.pos.x < 0: return null
	if data.pos.y >= 6 or data.pos.y < 0: return null
	return grid[data.side][data.pos.x][data.pos.y]

func setBlock(data, block):
	grid[data.side][data.pos.x][data.pos.y] = block

func checkColumnGravity(side, x):
	var distance = 0
	for y in range(6):
		if grid[side][x][y] == null: distance += 1
		elif !isBlockActive(grid[side][x][y]): distance += 1
		elif distance > 0:
			if grid[side][x][y].type != 'fixed' && grid[side][x][y].status != 'selected':
				grid[side][x][y].applyGravity(distance, offset[side].y - (45 * (y - distance)))
				grid[side][x][y - distance] = grid[side][x][y]
				grid[side][x][y] = null
			else:
				distance = 0

func isBlockActive(block):
	for block1 in get_tree().get_nodes_in_group("blocks"):
		if block1 == block: return true
	return false

func row(data, dir):
	if dir.x == -1: dir = Vector2(-1, 0)
	var success = SuccessArray.new()
	var pointer = data.clone()
	for _i in range(6):
		pointer.pos += dir
		if pointer.pos.x >= 6 or pointer.pos.x < 0 or pointer.pos.y >= 6 or pointer.pos.y < 0: break
		var block = getBlock(pointer)
		if block != null:
			if block.status == 'idle':
				success.add(block, 'indirect')
	return success

func bomb(data):
	var success = SuccessArray.new()
	for inc in [Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1)]:
		var pointer = data.clone()
		pointer.pos += inc
		if pointer.pos.x >= 6 or pointer.pos.x < 0 or pointer.pos.y >= 6 or pointer.pos.y < 0: continue
		var block = getBlock(pointer)
		if block != null && block.status == 'idle':
			success.add(block, 'indirect')
	return success

func score(n):
	get_node("/root/OnGame").score += n

func remains(n):
	get_node("/root/OnGame").remains -= n

func lastFreeLines():
	var result = { "left": 0, "right": 0 }
	for side in grid:
		for x in range(6):
			var pos = getFirstFreePositionOnColumn(side, x)
			if pos == null: pos = Vector2(x, 6)
			if pos != null && pos.y > result[side]: result[side] = pos.y
	return result

func shuffle():
	var sf = Shuffle.new(grid)
	
	for side in grid:
		for x in range(6):
			for y in range(6):
				if grid[side][x][y] != null:
					var block = sf.getRandomBlock()
					block.instant_pos(side, x, y)
					grid[side][x][y] = block

# Multiplayer

func vs_serie_action(counter):
	if get_node("/root/OnGame").multiplayer:
		if counter >= 4:
			get_node("/root/GooglePlayGameServices").sendBroadcastMessage("d.%d" % counter)

func add_flash_block():
	var block = blockClass.instance()
	block.init(getRandomFreePosition(), 'direct')
	get_node("/root/Game/VisualGrid/Blocks").add_child(block)
	block.joker()

# Operations

func get_filtered_blocks(filter=[]):
	"""
	Gets array of blocks filtered by filter array
	:filter: Array of types for filter
	"""
	var collection = []
	for side in grid:
		for x in range(6):
			for y in range(6):
				if grid[side][x][y] != null:
					var block = grid[side][x][y]
					if block.type in filter:
						collection.append(block)
	return collection

func hasFreePos():
	for side in grid:
		for x in range(6):
			for y in range(6):
				if grid[side][x][y] == null: return true
	return false

func getSideRandomFreePosition(side, height):
	var positions = []
	for data in getFreePositions(height):
		if data.side == side: positions.append(data)
	if positions.size() == 0: return null
	randomize()
	return positions[randi() % positions.size()]

func isEndGame():
	for side in grid:
		for x in range(6):
			if grid[side][x][5] == null:
				return false
	return true

func destroy_all():
	for side in grid:
		for x in range(6):
			for y in range(6):
				if grid[side][x][y] != null:
					grid[side][x][y].destroy(((6-y) * .05) + (x * .05))

func getRandomFreePosition():
	randomize()
	var positions = getFreePositions()
	if positions.size() == 0: return null
	return positions[randi() % positions.size()]

func getFreePositions(height = 6):
	var positions = []
	for side in grid:
		for x in range(6):
			if preview[side][x] == true: continue
			elif grid[side][x][5] != null: continue
			for y in range(height):
				if grid[side][x][y] == null:
					positions.append(Data.new(Vector2(x, y), side))
					break
	return positions

func getFirstFreePositionOnColumn(side, x):
	var pos = null
	for y in range(6):
		if pos == null && grid[side][x][y] == null: pos = Vector2(x, y)
		elif isBlockActive(grid[side][x][y]) && grid[side][x][y] != null:
			if grid[side][x][y].type == 'fixed': pos = null
	return pos
