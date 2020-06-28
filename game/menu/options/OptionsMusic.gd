extends HBoxContainer

func _ready():
	$"BtnSFX".set_pressed(!$"/root/Music".sfx)
	$"BtnMusic".set_pressed(!$"/root/Music".music)

func _on_BtnSFX_toggled(pressed):
	$"/root/Music".setSFXMuted(!pressed)
	$"/root/SaveGame".saveGame()

func _on_BtnMusic_toggled(pressed):
	$"/root/Music".setMusicMuted(!pressed)
	$"/root/SaveGame".saveGame()
