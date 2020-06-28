extends Node

var score = 0 setget setScore
var remains = 0 setget setRemains
var status = 'game'
var level = 1
var tutorial = false
var max_score = 0
var multi:bool = false

signal on_score
signal on_vs_score
signal on_vs_delete
signal on_vs_gift
# signal on_vs_levelup
signal on_remains
signal on_end_game
signal on_start_game

func _ready():
	pass

func getMaxScore():
	return max_score

func getTutorial():
	return tutorial

func setScore(n):
	score = n
	emit_signal("on_score", score)
	if multi:
		$"/root/GooglePlayGameServices".sendBroadcastMessage('s.%s' % str(score))

func setRemains(n):
	remains = n
	if remains <= 0:
		emit_signal("on_remains", 0)
		status = 'win'
		emit_signal("on_end_game")
	else:
		emit_signal("on_remains", remains)

func start(_level):
	status = 'game'
	emit_signal("on_start_game")

func changeLevel(level):
	self.level = level

func multiplayerMessage(_sender, msg):
	if $"/root/OnGame".multi == true:
		if msg == 'pause':
			$"/root/Game/Hud/PauseScreen".start("slave")
		if msg == 'continue':
			$"/root/Game/Hud/PauseScreen".stop()
		if msg == 'leave':
			$"/root/Game/Hud/PauseScreen".leaveGame()
		if msg == 'level_up':
			$"/root/Game/Hud/VSLabelsScreen".call("oponent level up")
			$"/root/Grid".shuffle()
		if msg.find('s.') >= 0:
			var vs_score = float(msg.split('.')[1])
			emit_signal("on_vs_score", vs_score)
		if msg.find('d.') >= 0:
			var counter = float(msg.split('.')[1])
			emit_signal("on_vs_delete", counter)
		if msg.find('g.') >= 0:
			var counter = float(msg.split('.')[1])
			var effects = ['row', 'bomb']
			emit_signal("on_vs_gift", effects[counter])
		print(msg)