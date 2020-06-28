extends HBoxContainer

var _err

func _ready():
	_err = $"/root/GooglePlayGameServices".connect("on_connect", self, "onConnect")
	_err = $"/root/GooglePlayGameServices".connect("on_disconnect", self, "onDisconnect")

func _on_BtnConnect_pressed():
	if get_node("BtnConnect").is_pressed():
		get_node("/root/GooglePlayGameServices").signIn()
		get_node("BtnConnect").set_disabled(true)
		get_node("BtnConnect").set_pressed(false)
	else:
		get_node("/root/GooglePlayGameServices").signOut()
		get_node("BtnConnect").set_disabled(true)
		get_node("BtnConnect").set_pressed(false)

func onConnect():
	get_node("BtnConnect").set_disabled(false)
	get_node("BtnConnect").set_pressed(true)
	
	get_node("BtnRanking").set_disabled(false)
	get_node("BtnAchievements").set_disabled(false)

func onDisconnect():
	get_node("BtnConnect").set_disabled(false)
	get_node("BtnConnect").set_pressed(false)
	
	get_node("BtnRanking").set_disabled(true)
	get_node("BtnAchievements").set_disabled(true)

func _on_BtnRanking_pressed():
	get_node("/root/GooglePlayGameServices").showLeaderList("CgkI4peP5IAKEAIQBw");

func _on_BtnAchievements_pressed():
	get_node("/root/GooglePlayGameServices").showAchyList();
