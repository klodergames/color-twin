extends Node2D

var pointsClass = preload("res://base/Points.tscn")

func start(n):
	for i in range(6):
		get_node("Bar" + str(i)).modulate.a = 0
	show()
	if n <= 5: showBlind(0)
	if n <= 4: showBlind(1)
	if n <= 3: showBlind(2)
	if n <= 2: showBlind(3)
	if n <= 1: showBlind(4)
	if n <= 0: showBlind(5)
	$Tween.start()

func showBlind(n):
	var obj = get_node("Bar" + str(n))
	$Tween.interpolate_property(obj, "modulate", Color(1,1,1,0), Color(1,1,1,1), .7, Tween.TRANS_BOUNCE, Tween.EASE_IN, n * .2)
	$Tween.interpolate_property(obj, "modulate", Color(1,1,1,.5), Color(1,1,1,1), .7, Tween.TRANS_BOUNCE, Tween.EASE_IN, (n * .2) + .7)
	
	var points = pointsClass.instance()
	points.position = obj.position
	add_child(points)
	points.start(100, n * .2)