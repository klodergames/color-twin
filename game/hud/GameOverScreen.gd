extends ReferenceRect

var _err
var remain = 10
var timer
var is_continue = false
var player
var player2

func _ready():
	setupSound()
	timer = get_node("Timer")

func setupSound():
	player = AudioStreamPlayer.new()
	player2 = AudioStreamPlayer.new()
	self.add_child(player)
	self.add_child(player2)
	player.stream = load("res://sfx/over.wav")
	player2.stream = load("res://sfx/timeout.wav")

func _on_EndGameScreen_input_event(ev):
	if ev.is_pressed():
		do_continue()

func start():
	$"/root/Grid".destroy_all()
	remain = 10
	is_continue = false
	_err = $Tween.interpolate_callback(self, 1, "start_delayed")
	$Tween.start()
	$"/root/Music".playLowPlease()
	if $"/root/Music".sfx:
		player.play()

func start_delayed():
	$Ready.text = "Ready0"
	$Ready.hide()
	$Number.hide()
	$Continue.show()
	timer.start()
	show()

func _on_Timer_timeout():
	if is_continue:
		if $Ready.is_visible():
			$Ready.hide()
			if $Ready.get_text() == "Go!":
				stop()
		else:
			if $"/root/Music".sfx:
				player2.play()
			if $Ready.get_text() == "Ready0":
				$Ready.set_text("Ready")
			elif $Ready.get_text() == "Ready":
				$Ready.set_text("Let's")
			elif $Ready.get_text() == "Let's":
				$Ready.set_text("Go!")
			$Ready.show()
	else:
		if get_node("Number").is_visible():
			get_node("Number").hide()
			remain -= 1
			if remain < 0:
				get_node("/root/Global").goto_scene("res://menu/Menu.tscn")
		else:
			if $"/root/Music".sfx:
				player2.play()
			$Number.text = str(remain)
			$Number.show()

func do_continue():
	$Continue.hide()
	$Number.hide()
	is_continue = true

func stop():
	hide()
	timer.stop()
	get_parent().get_parent().retry()
	$"/root/Music".playHight()
