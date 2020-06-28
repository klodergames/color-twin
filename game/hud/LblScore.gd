extends Label

var score = 0.0
var vs_score = 0.0
var next_score = 0.0
var vs_next_score = 0.0
var step = 0.0
var vs_step = 0.0

signal on_score_reach

func _ready():
	var _err = $"/root/OnGame".connect("on_score", self, "on_score")
	_err = $"/root/OnGame".connect("on_vs_score", self, "on_vs_score")
	_err = $Timer.connect("timeout", self, "on_timeout")
	_err = $VsTimer.connect("timeout", self, "on_vs_timeout")

func on_score(next_score):
	self.next_score = float(next_score)
	step = float(next_score - score) / 20.0
	get_node("Timer").start()

func on_vs_score(vs_next_score):
	self.vs_next_score = float(vs_next_score)
	vs_step = float(vs_next_score - vs_score) / 20.0
	get_node("VsTimer").start()

func on_timeout():
	if get_node("/root/OnGame").multiplayer:
		set_text("%d vs %d" % [floor(score),floor(vs_score)])
	else:
		set_text("%d" % floor(score))
	
	if score >= next_score:
		score = next_score
		get_node("Timer").stop()
		emit_signal("on_score_reach")
	else:
		score += step

func on_vs_timeout():
	if get_node("/root/OnGame").multiplayer:
		set_text("%d vs %d" % [floor(score),floor(vs_score)])
	
	if vs_score >= vs_next_score:
		vs_score = vs_next_score
		get_node("VsTimer").stop()
		emit_signal("on_vs_score_reach")
	else:
		vs_score += vs_step