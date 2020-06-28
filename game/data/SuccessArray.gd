
var success = []

func clear():
	success = []

func add(block, mode):
	if not has(block, mode):
		success.append({ "block": block, "mode": mode })

func addElement(elem):
	add(elem['block'], elem['mode'])

func has(block, mode = 'direct'):
	for elem in success:
		if elem['block'].data.side == block.data.side and elem['block'].data.pos == block.data.pos:
			if mode == 'direct': elem['mode'] = mode
			return true
	return false

func append(newSuccess):
	for elem in newSuccess.success: addElement(elem)

func action():
	for elem in success:
		elem['block'].success(elem['mode'])

func debug():
	for elem in success:
		print(elem['block'].data.pos)

func size():
	return success.size()