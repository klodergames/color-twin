extends Node2D

var timer
var player

var colors = ["#BA01FF", "#B6FF00", "#FFCA1B", "#228DFF", "#FF0092"]

func _ready():
	setupSound()
	timer = get_node("Timer")
	timer.connect("timeout", self, "on_timeout")

func setupSound():
	player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://sfx/bomb.wav")

func explode(color):
	var c = Color(colors[color])
	$Particles2D.process_material.color = c
	$Particles2D.emitting = true
	if $"/root/Music".sfx:
		player.play()
	timer.start()

func on_timeout():
	queue_free()