extends Node2D

var level = 1
var limits = [1,90]

func _ready():
	level = get_node("/root/OnGame").level
	updateLabel()

func updateLabel():
	get_node("Label").set_text("%02d" % level)
	checkButtonVisibility()
	get_node("/root/OnGame").changeLevel(level)

func checkButtonVisibility():
	if level <= limits[0]: get_node("BtnLeft").hide()
	else: get_node("BtnLeft").show()
	if level >= limits[1]: get_node("BtnRight").hide()
	else: get_node("BtnRight").show()

func _on_BtnRight_pressed():
	level += 1
	if level > limits[1]: level = limits[1]
	updateLabel()

func _on_BtnLeft_pressed():
	level -= 1
	if level < limits[0]: level = limits[0]
	updateLabel()
