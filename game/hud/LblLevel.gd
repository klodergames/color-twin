extends Label

var level = 0
var blocks = 0
var _err

func _ready():
	_err = $"/root/OnGame".connect("on_remains", self, "on_remains")

func set_level(level):
	self.level = level

func set_blocks(blocks):
	self.blocks = blocks

func on_remains(remains):
	setRemains(remains)

func setRemains(remains):
	set_text("%d/%d - Lvl %d" % [remains, blocks, level])
