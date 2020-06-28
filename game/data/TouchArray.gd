
var touchs = []

func add(index):
	touchs.append({ "index": index, "points": [] })

func getAll():
	return touchs

func get(index):
	for touch in touchs:
		if touch['index'] == index: return touch

func remove(index):
	for i in range(touchs.size()):
		if touchs[i]['index'] == index:
			touchs.remove(i)

func has(index):
	for touch in touchs:
		if touch['index'] == index: return true
	return false

func clear():
	touchs = []