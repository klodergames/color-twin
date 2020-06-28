extends Node

var file_name = "user://savedata.bin"
var fixed_key = "1c982991977eb92f18559476c73040a2b2ccee1e"

func _ready() -> void:
	loadGame()

# State
# -----------------------------------------------------------------

# TODO: Why two GooglePlayGameServices signIn service

func setState(state:Dictionary) -> void:
	if state.has("connected") and state.connected: $"/root/GooglePlayGameServices".autoSignIn()
	if state.has("max_score"): $"/root/OnGame".max_score = state.max_score
	if state.has("tutorial"): $"/root/OnGame".tutorial = state.tutorial
	if state.has("level"): $"/root/OnGame".level = int(state.level)
	if state.has("music"): $"/root/Music".music = state.music
	if state.has("sfx"): $"/root/Music".sfx = state.sfx
	if state.has("connected") && state.connected: $"/root/GooglePlayGameServices".signIn()

func getState() -> Dictionary:
	return {
		"connected": $"/root/GooglePlayGameServices".connected,
		"max_score": $"/root/OnGame".max_score,
		"tutorial": $"/root/OnGame".tutorial,
		"level": $"/root/OnGame".level,
		"music": $"/root/Music".music,
		"sfx": $"/root/Music".sfx
	}

# Logic
# -----------------------------------------------------------------

func saveGame() -> void:
	var file = File.new()
	var key = OS.get_unique_id()
	if key == "": key = fixed_key
	var _err = file.open_encrypted_with_pass(file_name, File.WRITE, key)
	file.store_line(to_json(getState()))
	file.close()

func loadGame() -> void:
	var file:File = File.new()
	if !file.file_exists(file_name):
		return #Error! We dont have savegame yet
	
	var json:Dictionary = {}
	var key:String = getUniqueKey()
	var _err:int = file.open_encrypted_with_pass(file_name, File.READ, key)
	json = parse_json(file.get_line())
	
	if json == null:
		return #Error! We dont have savegame yet
	
	setState(json)
	file.close()

func getUniqueKey() -> String:
	var key:String = OS.get_unique_id()
	if key == "":
		key = fixed_key
	return key
