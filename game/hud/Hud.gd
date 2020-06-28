extends CanvasLayer

var level:int = 0
var sfxWin:AudioStreamPlayer

func _ready():
	setupSFX()
	var _err:int = $"/root/OnGame".connect("on_end_game", self, "on_end_game")

func setupSFX() -> void:
	sfxWin = AudioStreamPlayer.new()
	add_child(sfxWin)
	sfxWin.stream = load("res://sfx/win.wav")

func start(n, level):
	if self.level == 0: $LabelsScreen.call("GO")
	else: $LabelsScreen.call("LEVEL UP")
	self.level = n
	$LblLevel.set_level(n)
	$LblLevel.set_blocks(level['remains'])
	$"/root/OnGame".remains = level['remains']

func on_end_game():
	if $"/root/Music".sfx:
		sfxWin.play()
	$BtnPause.hide()
	var _err = $Timer.connect("timeout", self, "on_wait_timeout")
	$Timer.start()

func on_wait_timeout():
	$Timer.disconnect("timeout", self, "on_wait_timeout")
	var lfl = $"/root/Grid".lastFreeLines()
	$BlindLeft.start(lfl['left'])
	$BlindRight.start(lfl['right'])
	for side in ['left', 'right']:
		$"/root/OnGame".score += (6 - lfl[side]) * 100
	var _err = $LblScore.connect("on_score_reach", self, "on_score_reach")

func on_score_reach():
	$LblScore.disconnect("on_score_reach", self, "on_score_reach")
	var _err = $Timer.connect("timeout", self, "on_timeout")
	$Timer.start()

func on_timeout():
	$Timer.disconnect("timeout", self, "on_timeout")
	$BlindLeft.hide()
	$BlindRight.hide()
	$BtnPause.show()
	get_parent().next()

func _on_BtnPause_pressed():
	if $"/root/OnGame".multi == true:
		$"/root/GooglePlayGameServices".sendBroadcastMessage('pause')
	$PauseScreen.start()
