func getLevel(num):
	return {
		"left": {
			"blocks": _getLeftBlocks(num),
			#"fix": [{ "x": 2, "y": 2 }],
			"height": _getLeftHeight(num)
		},
		"right": {
			"blocks": _getRightBlocks(num),
			#"fix": [{ "x": 2, "y": 2 }],
			"height": _getRightHeight(num)
		},
		"remains": _getRemains(num),
		"speed": _getSpeed(num)
	}

func _getRemains(num):
	return (((num - 1) % 10)  * 10) + 20

# Seconcs to next block
func _getSpeed(num):
	if num <= 10: return 1
	return 1.0 - ((num % 10) / 10.0)

func _getLeftBlocks(num):
	if num >= 21 && num <= 23:
		return 6
	if num >= 24 && num <= 27:
		return 12
	if num >= 28 && num <= 30:
		return 18
	
	if num >= 51 && num <= 53:
		return 6
	if num >= 54 && num <= 57:
		return 12
	if num >= 58 && num <= 60:
		return 18
	
	if num >= 81 && num <= 83:
		return 6
	if num >= 84 && num <= 87:
		return 12
	if num >= 88 && num <= 90:
		return 18
	
	return 0

func _getRightBlocks(num):
	return _getLeftBlocks(num)

func _getLeftHeight(num):
	if num >= 21 && num <= 23:
		return 1
	if num >= 24 && num <= 27:
		return 2
	if num >= 28 && num <= 30:
		return 3
	
	if num >= 51 && num <= 53:
		return 1
	if num >= 54 && num <= 57:
		return 2
	if num >= 58 && num <= 60:
		return 3
	
	if num >= 81 && num <= 83:
		return 1
	if num >= 84 && num <= 87:
		return 2
	if num >= 88 && num <= 90:
		return 3
	
	return 0

func _getRightHeight(num):
	return _getLeftHeight(num)

func dummyLevel():
	return {
		"left": {
			"blocks": 18,
			"fix": [{ "x": 2, "y": 2 }],
			"height": 2
		},
		"right": {
			"blocks": 18,
			"fix": [{ "x": 2, "y": 2 }],
			"height": 2
		},
		"remains": 2,
		"speed": 1 # Seconcs to next block
	}