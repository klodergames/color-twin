var blocks = []

func _init(grid):
	for side in grid:
		for x in range(6):
			for y in range(6):
				if grid[side][x][y] != null:
					var block = grid[side][x][y]
					blocks.append(block)

func getRandomBlock():
	var index = randi() % blocks.size()
	var block = blocks[index]
	blocks.remove(index)
	return block
