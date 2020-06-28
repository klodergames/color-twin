extends Node

var streamPlayer:AudioStreamPlayer

var music:bool = false
var sfx:bool = false

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	streamPlayer = AudioStreamPlayer.new()
	streamPlayer.stream = load("res://music/music.ogg")
	add_child(streamPlayer)

func playAgainSam() -> void:
	if music:
		streamPlayer.play()

func playLowPlease() -> void:
	if music:
		streamPlayer.volume_db = -10.0

func playHight() -> void:
	if music:
		streamPlayer.volume_db = 0.0

func stopPlaying() -> void:
	streamPlayer.stop()

# Setters
# -----------------------------------------------------------------

func setMusicMuted(val: bool) -> void:
	music = val
	if music: streamPlayer.volume_db = 0.0
	else: streamPlayer.volume_db = 1.0

func setSFXMuted(val: bool) -> void:
	sfx = val

# For Save Game
# -----------------------------------------------------------------

func getState() -> Dictionary:
	return { "music": music, "sfx": sfx }

func setState(value: Dictionary) -> void:
	music = value.music
	sfx = value.sfx