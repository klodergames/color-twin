extends Node

var gpgs = null
var connected = false
var auto = false # Auto signin

signal on_connect
signal on_disconnect

func _ready():
	if Engine.has_singleton("GodotGooglePlayGameServices"):
		gpgs = Engine.get_singleton("GodotGooglePlayGameServices")
		gpgs.init(OS.get_unique_id())

# Login/Logout
# ------------------------------------------------------------------------------

func autoSignIn():
	auto = true

func _on_google_play_game_services_initiated():
	if auto:
		signIn()

func signIn():
	if gpgs != null:
		gpgs.signIn()

func signOut():
	connected = false
	if gpgs != null:
		gpgs.signOut()
	$"/root/SaveGame".saveGame()

func _on_google_play_game_services_connected():
	connected = true
	emit_signal("on_connect")
	$"/root/SaveGame".saveGame()

func _on_google_play_game_services_disconnected():
	connected = false
	emit_signal("on_disconnect")

func _on_google_play_game_services_suspended_network_lost():
	connected = false
	emit_signal("on_disconnect")

func _on_google_play_game_services_suspended_service_disconnected():
	connected = false
	emit_signal("on_disconnect")

func _on_google_play_game_services_suspended_unknown():
	connected = false
	emit_signal("on_disconnect")

func _on_google_play_game_services_connection_failed():
	connected = false
	emit_signal("on_disconnect")

# Achievements
# ------------------------------------------------------------------------------

func unlockAchy(id):
	if gpgs != null:
		gpgs.unlockAchy(id)
		$"/root/Firebase".unlockAchievement(id)

func showAchyList():
	if gpgs != null:
		gpgs.showAchyList()

# Leaderboards
# ------------------------------------------------------------------------------

func leaderSubmit(leaderboard, value):
	if gpgs != null:
		gpgs.leaderSubmit(leaderboard, value)

func showLeaderList(leaderboard):
	if gpgs != null:
		gpgs.showLeaderList(leaderboard)

# Real Time Multiplayers
# ------------------------------------------------------------------------------

func invitePlayers(minimum, maximum):
	if gpgs != null:
		gpgs.invitePlayers(minimum, maximum)

func showInvitationInbox():
	if gpgs != null:
		gpgs.showInvitationInbox()

func sendBroadcastMessage(msg):
	if gpgs != null:
		gpgs.sendBroadcastMessage(msg)

func leaveRoom():
	if gpgs != null:
		gpgs.leaveRoom()

func _on_gpgs_rtm_start_game():
	if gpgs != null:
		$"/root/OnGame".multi = true
		$"/root/Global".goto_scene("res://Game.tscn")

func _on_gpgs_rtm_message_received(sender, msg):
	if gpgs != null:
		$"/root/OnGame".multiplayerMessage(sender, msg)

func _on_gpgs_rtm_disconnected_from_room():
	if gpgs != null:
		$"/root/OnGame".multi = false
		get_tree().set_pause(false)
		$"/root/Global".goto_scene("res://menu/Menu.tscn")