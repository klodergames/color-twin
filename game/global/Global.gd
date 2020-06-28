extends Node

var loader
var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

# Scene change
# -----------------------------------------------------------------

func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# current_scene.free()
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		return
	
	set_process(true)

func _process(_delta):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	
	var err = loader.poll()
	if err == ERR_FILE_EOF: # load finished
		var resource = loader.get_resource()
		loader = null
		set_process(false)
		set_new_scene(resource)
		return
	elif err == OK:
		# update_progress()
		pass
	else: # error during loading
		# show_error()
		loader = null
		set_process(false)
		return

func set_new_scene(scene_resource):
	current_scene.free()
	current_scene = scene_resource.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)