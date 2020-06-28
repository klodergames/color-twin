var serie = []
var color = null
var action = 'fail'

var successArray = preload("res://data/SuccessArray.gd").new()

# Operations

func add(block):
	# Add if is new to serie and not null
	if check(block):
		serie.append(block)

func clear():
	color = null
	action = 'none'
	serie = []

func has(pos):
	for block in serie:
		if block.data.pos == pos: return true
	return false

func check(block):
	# Check if block is null
	if block == null:
		# action = 'fail' # Fail
		return false # Not count
	
	# Check if block is falling
	if block.status == 'selected': return false # Not count
	
	# Check if not exists yet
	if has(block.data.pos): return false # Not count
	
	# Check if block is falling
	if block.status == 'falling': return false # Not count
	
	# If is fixed block
	if block.type == 'fixed':
		action = 'fail'
		return true # Not count
	
	# Check if is the first
	if color == null && action == 'none':
		color = block.color
		action = 'success' # Start with success
		return true
	
	# if the side of the first is not the same
	if serie[0].data.side != block.data.side:
		action = 'fail' # Do Fail
		return true # Add to the count
	
	# If color is the same and we are ok
	if color == block.color && action == 'success':
		# If the position are not sibiling and not diagonal
		if checkPos(block): return true
		else:
			action = 'fail' # Do Fail
			return true # Add to the count
	
	# In any other case
	action = 'fail'
	return true # But include on list

func checkPos(block1):
	for block2 in serie:
		var diff = block1.data.pos - block2.data.pos
		if diff == Vector2(1, 0) or diff == Vector2(0, 1) or diff == Vector2(-1, 0) or diff == Vector2(0, -1):
			return true
	return false

# Actions

func doAction(grid):
	if serie.size() < 2: action = 'fail'
	if action == 'fail': mistake()
	elif action == 'success': success(grid)

func mistake():
	for block in serie: block.mistake()

func success(grid):
	successArray.clear()
	for block in serie:
		if block.type == 'row':
			var dir = Vector2(0, 1).rotated(-block.rotation)
			successArray.append(grid.row(block.data, dir))
		elif block.type == 'bomb':
			successArray.append(grid.bomb(block.data))
		successArray.add(block, 'direct')
	
	# successArray.debug()
	grid.vs_serie_action(serie.size())
	successArray.action()
	
	grid.score(serie.size() * 10)
	grid.remains(successArray.size())

func equal(d1, d2):
	if d1.side == d2.side && d1.pos == d2.pos: return true
	return false