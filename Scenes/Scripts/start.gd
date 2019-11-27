extends Node2D

func _process(delta):
	get_node("Mouse").set_position(get_local_mouse_position())
func start_game():
	$AnimationPlayer.play_backwards("start")
	sfx_handler.play("button")
	get_node("MenuButton").visible = false
	get_node("Mouse").monitoring = false
	get_node("BG/quit").disabled = true
	get_node("BG/start").disabled = true
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Scenes/doll_is_promised.tscn")
	
func quit_game():
	sfx_handler.play("button")
	yield(get_tree(), "idle_frame")
	get_tree().quit()
func _ready():
	if global.ended == false:
		music_handler.get_node("title").play()
	$AnimationPlayer.play("start")
	get_node("MenuButton").visible = true
func start(obj, key):
	get_tree().change_scene("res://Scenes/doll_is_promised.tscn")
	
func interactable(body):
	print('int able')
	global.current_npc = body
	print (global.current_npc)
	Input.set_custom_mouse_cursor(global.mouse_1)
	global.int_able = true
#	current_npc = body
	pass # Replace with function body.
	
func uninteractable(body):
	print("int unable")
	Input.set_custom_mouse_cursor(null)
	global.current_npc = null
	print(global.current_npc)
	global.int_able = false