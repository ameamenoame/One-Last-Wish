extends Node2D


onready var smrt = get_node('CanvasLayer/SMRT')

func _ready():
	get_node("BG").fade_out()
	sfx_handler.get_node("train").play()
	dia("intro", "1")

func _process(delta):
	get_node("Mouse").set_position(get_local_mouse_position())
#	print(get_node("Mouse").position)
	if sfx_handler.get_node("rain").is_playing():
		if not $VideoPlayer.is_playing():
			$VideoPlayer.play()
		
	pass
	

# IMPORTANT: function responsible for dialogue creation
func dia(chapter, dialogue, start_at=0):
	#global.char_movement = false
	global.int_able = false
	global.in_dialog = true
	smrt.show_text(chapter, dialogue, start_at)
	yield(smrt, "finished")
	#starts artificial delay
	get_node("Mouse/delay").start()

func  _physics_process(delta): 
	# dialogue code
	if Input.is_mouse_button_pressed(1) and global.int_able == true and global.current_npc != null and global.in_dialog == false: 
		print("interactable")
		print(global.current_npc)
		print(global.current_npc.dia_id)
		# handles area player clicked on, get the necessary flags and if initiated a dialogue tracks the number of time it happened
		if global.current_npc.get("dia_flag") == true: 
			print("body has dialogue, proceeds to chat")
			if global.dia_track.has(global.current_npc.get("dia_id")) == false:
				global.dia_track[global.current_npc.get("dia_id")] = 1
				print("sucess")
			self.dia(global.current_npc.get("dia_id"), str(global.dia_track[global.current_npc.get("dia_id")]))
			if global.dia_track[global.current_npc.get("dia_id")] < global.current_npc.get("max_dia"):
				global.dia_track[global.current_npc.get("dia_id")] = global.dia_track[global.current_npc.get("dia_id")] + 1
			print (global.dia_track)
		if global.current_npc.get("dia_id") == "truck":
			print("truck hit")
			$AnimationPlayer.play_backwards("fog")
			get_node("Mouse").monitoring = false
			smrt.stop()
			get_node("BG").fade_in()
			music_handler.get_node("title").stop()
			music_handler.get_node("ending").stop()			
			get_node("BG/delayed_action").wait_time = 3
			get_node("BG/delayed_action").start()
			yield(get_node("BG/delayed_action"), "timeout")
			sfx_handler.stop("rain")
			get_tree().change_scene("res://Scenes/angel.tscn")
		pass
	# change world code
#	if global.near_portal == true:
#		$popup.set_visible(true)
#		if Input.is_action_just_released("interact"):
#			print("change world")
#			$popup.set_visible(false)
#			emit_signal("changeWorld")



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



# mega-function for managing dynamic dialogue
func _on_SMRT_dialog_control(info):
	print ("dialog control")
	# let things happen on specific text, dialog points
	if (info.chapter == "intro" and info.dialog == "1" and info.last_text_index == 7):
		delayed_dialogue("intro", "2", "BG2")
		sfx_handler.stop("train")
		yield(get_tree().create_timer(1.0), "timeout")
		sfx_handler.play("typing")
	elif (info.chapter == "intro" and info.dialog == "2" and info.last_text_index == 8):
		delayed_dialogue("intro", "3", "BG3", true)
		sfx_handler.stop("typing")
		yield(get_tree().create_timer(1.0), "timeout")		
		$VideoPlayer.play()
		sfx_handler.play("rain")
	elif (info.chapter == "intro" and info.dialog == "3" and info.last_text_index == 15):
		get_node("BG").fade_out()
		$BG/BG2.visible = false
		$BG.self_modulate.a = 0
		get_node("BG").fade_in("BG3")
		$AnimationPlayer.play("fog")
		yield(get_node("BG/action_tween"), "tween_completed")
		get_node("Mouse").monitoring = true
		
		# click bus to continue
#		get_tree().change_scene("res://Scenes/angel.tscn")

# reuseable method for creating dialogue after a delay
func delayed_dialogue(chapter, dialog, bg, black_transition=false, time=1):
	if (black_transition == true):
		get_node("BG").fade_in()
		yield(get_node("BG/action_tween"), "tween_completed")
	# starts delay 
	get_node("BG/delayed_action").wait_time = time
	get_node("BG/delayed_action").start()
	yield(get_node("BG/delayed_action"), "timeout")
	# fades in parameter bg
	get_node("BG").fade_in(bg)
	yield(get_node("BG/action_tween"), "tween_completed")
	# creates dialogue when bg is fully visible
	dia(chapter, dialog)



func _on_Mouse_area_exited(area):
	pass # Replace with function body.
