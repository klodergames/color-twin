extends Node2D

var color = 0
var tween = null
var grid = null
var data = null

var mode = 'direct'   # 'direct' or 'preview'
var type = 'color'    # 'color', 'fixed', ('bomb', 'row')
var status = 'idle'   # 'idle', 'falling', 'selected', 'gravity'
var success_mode = 'direct' # 'direct' or 'indirect'

var bombEffectClass = preload("res://blocks/BombEffect.tscn")
var rowEffectClass = preload("res://blocks/RowEffect.tscn")
var pointsClass = preload("res://base/Points.tscn")

var vh = {
	"color": 0, "fixed": 0,
	"bomb": 1,
	"row": 2
}

# The desired position
var next_pos = Vector2()
var vel = Vector2()
var gravity = Vector2(0, 98)

func init(data, mode = 'direct', type = 'color'):
	self.data = data
	self.mode = mode
	self.type = type

func _ready():
	if tween == null:
		tween = get_node("Tween")
		grid = get_node("/root/Grid")
		setProps()
		# If is preview mode
		if mode == 'preview': preview()
		# If is direct mode
		else:
			position = data.getPos()
			grid.setBlock(data, self)

func setProps():
	# Initial color
	randomize()
	color = randi() % 5
	
	# Fixed
	if type == 'fixed': color = 5
	# Row
	elif randi() % 2 == 1:
		type = 'row'
		var rot = (randi() % 4) * 90
		rotation = deg2rad(rot)
	# Bomb
	elif randi() % 20 == 1: type = 'bomb'
	$Sprite.set_region_rect(Rect2(color * 36, vh[type] * 36, 36, 36))

func joker():
	$Joker.start()
	mistake()

func remove_effect():
	type = "color"
	$Sprite.set_region_rect(Rect2(color * 36, vh[type] * 36, 36, 36))
	joker()

func add_effect(type_effect):
	type = type_effect
	$Sprite.set_region_rect(Rect2(color * 36, vh[type] * 36, 36, 36))
	mistake()

func preview():
	position = data.getPreviewPos()
	modulate.a = 0
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position", position, position + Vector2(0, 18), 1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_completed", self, "on_preview_finished")
	tween.start()

func on_preview_finished(_object, _key):
	tween.disconnect("tween_completed", self, "on_preview_finished")
	
	var newParent = get_node("/root/Game/VisualGrid/Blocks")
	get_node("/root/Game/Preview/Blocks").remove_child(self)
	newParent.add_child(self)
	
	grid.preview[data.side][data.pos.x] = false
	
	data.pos = grid.getFirstFreePositionOnColumn(data.side, data.pos.x)
	next_pos = grid.offset[data.side] + (data.pos * Vector2(45, -45))
	grid.setBlock(data, self)
	status = 'falling'
	set_process(true)

func instant_pos(side, x, y):
	set_process(false)
	position = grid.offset[side] + (Vector2(x, y) * Vector2(45, -45))
	data.pos = Vector2(x, y)
	data.side = side
	status = 'idle'

func _process(delta):
	if next_pos != position:
		vel += gravity * delta
		if position.y + vel.y >= next_pos.y:
			if abs(vel.y) > 5:
				vel *= -1
				vel /= 2
			else:
				status = 'idle'
				set_process(false)
				position = next_pos
				vel = Vector2()
		else:
			position += vel

func mistake():
	tween.interpolate_property(self, "transform/scale", Vector2(1.5, 1.5), Vector2(1, 1), .7, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()

func applyGravity(distance, y):
	if status != 'selected':
		next_pos = Vector2(position.x, y)
		status = 'gravity'
		data.pos.y -= distance
		set_process(true)

func success(success_mode):
	self.success_mode = success_mode
	status = 'selected'
	if type == 'bomb' && success_mode == 'direct':
		var be = bombEffectClass.instance()
		be.position = position
		get_parent().get_parent().add_child(be)
		#get_parent().get_parent().get_node("SamplePlayer2D").play("bomb")
		be.explode(color)
	elif type == 'row' && success_mode == 'direct':
		var re = rowEffectClass.instance()
		re.position = position
		get_parent().get_parent().add_child(re)
		re.row(color, rotation, data)
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.connect("tween_completed", self, "on_success_finish1")
	tween.start()
	
	var points = pointsClass.instance()
	points.position = position
	get_parent().get_parent().add_child(points)
	points.start(10)

func on_success_finish1(_obj, _key):
	grid.removeBlock(data)
	tween.disconnect("tween_completed", self, "on_success_finish1")
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_completed", self, "on_success_finish2")

func on_success_finish2(_obj, _key):
	tween.disconnect("tween_completed", self, "on_success_finish2")
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_completed", self, "on_success_finish")

func destroy(delay):
	tween.stop_all()
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), .7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	tween.connect("tween_completed", self, "on_destroy_finish")
	tween.start()

func on_destroy_finish(_obj, _key):
	queue_free()

func on_success_finish(_obj, _key):
	tween.disconnect("tween_completed", self, "on_success_finish")
	queue_free()