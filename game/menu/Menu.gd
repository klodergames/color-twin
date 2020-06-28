extends Node2D

func _ready():
	$"/root/Music".stopPlaying()
	main()
	if $"/root/GooglePlayGameServices".auto:
		$"/root/GooglePlayGameServices".signIn()

func options():
	$Options.showScreen()

func credits():
	$Credits.showScreen()

func main():
	$Main.showScreen()
