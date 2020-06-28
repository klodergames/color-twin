extends ReferenceRect

var game

func _ready():
	game = get_parent().get_parent()

func start(mode="master"):
	# Check vs mode
	if mode == "slave":
		$VBoxContainer/BtnContinue.hide()
	else:
		$VBoxContainer/BtnContinue.show()
	show()
	$Timer.start()
	$"/root/Music".playLowPlease()
	game.get_node("Preview").hide()
	game.get_node("VisualGrid/Blocks").hide()
	game.get_node("Draw").stop()
	get_parent().get_node("BtnPause").hide()
	get_tree().set_pause(true)

func stop():
	hide()
	$Timer.stop()
	$"/root/Music".playHight()
	game.get_node("Preview").show()
	game.get_node("VisualGrid/Blocks").show()
	game.get_node("Draw").start()
	get_parent().get_node("BtnPause").show()
	get_tree().set_pause(false)

func leaveGame():
	get_tree().set_pause(false)
	$"/root/Global".goto_scene("res://menu/Menu.tscn")

func _on_Timer_timeout():
	if $Title.is_visible():
		$Title.hide()
	else:
		$Title.show()

func _on_BtnContinue_pressed():
	if $"/root/OnGame".multi == true:
		$"/root/GooglePlayGameServices".sendBroadcastMessage('continue')
	stop()

func _on_BtnLeaveGame_pressed():
	if $"/root/OnGame".multi == true:
		$"/root/OnGame".multi = false
		$"/root/GooglePlayGameServices".leaveRoom()
	leaveGame()
