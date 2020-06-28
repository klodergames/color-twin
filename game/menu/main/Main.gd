extends Node2D

var menuAnimation = load("res://libs/MenuAnimation.gd").new()
var soundNeon
var screen
var _err

func _ready():
	setupSFX()
	screen = get_viewport_rect().size
	_err = $"/root/GooglePlayGameServices".connect("on_connect", self, "onConnect")
	_err = $"/root/GooglePlayGameServices".connect("on_disconnect", self, "onDisconnect")
	add_child(menuAnimation)
	menuAnimation.init([$LblTitle, $InsertCoin, $Btn1P, $Btn2PConnect, $BtnShowInvitationInbox,
		$LevelSelector, $BtnMenu, $BtnInfo], .2)

func setupSFX():
	soundNeon = AudioStreamPlayer.new()
	add_child(soundNeon)
	soundNeon.stream = load("res://menu/neon.wav")
	soundNeon.volume_db = -10.0

# Screens
# -----------------------------------------------------------------------------

func showScreen():
	set_scale(Vector2(1,1))
	menuAnimation.on()
	show()
	if $"/root/Music".sfx:
		soundNeon.play()
	if $"/root/GooglePlayGameServices".connected:
		$"Btn2P".set_disabled(false)

func hideScreen():
	var delay = menuAnimation.off()
	$HideScreen.interpolate_property(self, "scale", Vector2(1,1), Vector2(3,3), .3, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	$HideScreen.start()

func _on_HideScreen_tween_completed(_object, _key):
	hide()

# Buttons
# -----------------------------------------------------------------------------

func _on_BtnMenu_pressed():
	hideScreen()
	get_parent().options()

func _on_Btn1P_pressed():
	$"/root/Global".goto_scene("res://Game.tscn")

func _on_BtnInfo_pressed():
	hideScreen()
	get_parent().credits()

func _on_Btn2P_pressed():
	$"/root/GooglePlayGameServices".invitePlayers(1, 1)

func _on_BtnShowInvitationInbox_pressed():
	$"/root/GooglePlayGameServices".showInvitationInbox()

func _on_Btn2PConnect_pressed():
	$"/root/GooglePlayGameServices".signIn()

# GPGS
# -----------------------------------------------------------------------------

func onConnect():
	$"Btn2PConnect".hide()
	$"Btn2P".show()
	$"BtnShowInvitationInbox".set_disabled(false)

func onDisconnect():
	$"Btn2P".hide()
	$"Btn2PConnect".show()
	$"BtnShowInvitationInbox".set_disabled(true)