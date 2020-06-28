extends ReferenceRect

func call(text):
	$Label.text = text
	$AnimationPlayer.play("go")
