extends Node2D

var menuAnimation = load("res://libs/MenuAnimation.gd").new()
var soundNeon
var screen

func _ready():
	setupSFX()
	screen = get_viewport_rect().size
	add_child(menuAnimation)
	menuAnimation.init([$LblTitle, $BtnBack, $RichTextLabel], .2)

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

func hideScreen():
	var delay = menuAnimation.off()
	$HideScreen.interpolate_property(self, "scale", Vector2(1,1), Vector2(3,3), .3, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	$HideScreen.start()

func _on_HideScreen_tween_completed(_object, _key):
	hide()

# Buttons
# -----------------------------------------------------------------------------

func _on_BtnBack_pressed():
	hideScreen()
	get_parent().main()
