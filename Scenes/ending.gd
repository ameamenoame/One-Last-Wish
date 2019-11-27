extends Node2D

# reminder to make unique this script when creating a new scene

onready var smrt = get_node('CanvasLayer/SMRT')

# tracks what the cursor is interacting with
func _process(delta):
	get_node("Mouse").set_position(get_local_mouse_position())
##	print(get_node("Mouse").position)
#	if Input.is_action_just_pressed("ui_cancel"):
#		print ('ye')
#
#	pass
	

# IMPORTANT: function responsible for dialogue creation
func dia(chapter, dialogue, start_at=0):
	#global.char_movement = false
	global.int_able = false
	global.in_dialog = true
	smrt.show_text(chapter, dialogue, start_at)
	yield(smrt, "finished")
	#starts artificial delay
	get_node("CanvasLayer/delay").start()

func  _physics_process(delta): 
	# creates dialogue for an interactable object
	if Input.is_mouse_button_pressed(1) and global.int_able == true and global.current_npc != null and global.in_dialog == false: 
		print("interactable")
		print(global.current_npc)
		# handles area player clicked on, get the necessary flags, and if successfully initiated a dialogue, tracks the number of time it happened
		if global.current_npc.get("dia_flag") == true: 
			print("body has dialogue, proceeds to chat")
			if global.dia_track.has(global.current_npc.get("dia_id")) == false:
				global.dia_track[global.current_npc.get("dia_id")] = 1
				print("success")
			self.dia(global.current_npc.get("dia_id"), str(global.dia_track[global.current_npc.get("dia_id")]))
			if global.dia_track[global.current_npc.get("dia_id")] < global.current_npc.get("max_dia"):
				global.dia_track[global.current_npc.get("dia_id")] = global.dia_track[global.current_npc.get("dia_id")] + 1
			print (global.dia_track)
		pass
#	# change world code
#	if global.near_portal == true:
#		$popup.set_visible(true)
#		if Input.is_action_just_released("interact"):
#			print("change world")
#			$popup.set_visible(false)
#			emit_signal("changeWorld")


# two functions that handle object interactivity
func interactable(body):
	print('int able')
	global.current_npc = body
	print (global.current_npc)
	Input.set_custom_mouse_cursor(global.mouse_1)
	global.int_able = true
#	current_npc = body
	
func uninteractable(body):
	print("int unable")
	Input.set_custom_mouse_cursor(null)
	global.current_npc = null
	print(global.current_npc)
	global.int_able = false

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

#################################################
#BELOW THIS IS WHERE YOU HANDLE DYNAMIC DIALOGUE#
#################################################

# handles what happens when the scene starts
func _ready():
	music_handler.get_node("title").stop()
	music_handler.get_node("ending").play(4.0)
	dia("ending", "1")
	yield(smrt, "finished")
	get_node("BG").fade_in("transition", 6.0)
	yield($BG/action_tween, "tween_completed")
	yield(get_tree().create_timer(2.0), "timeout")
	$AnimationPlayer.play('ending')
#	get_tree().change_scene("res://Scenes/intro.tscn")

# mega-function for managing dynamic dialogue
func _on_SMRT_dialog_control(info):
	# let things happen on specific text, dialog points
	if (info.last_text_index == 12):
		$BG.fade_out()
	elif (info.last_text_index == 22):
		$BG.fade_in("BG2")
	elif (info.last_text_index == 32):
		$BG.fade_in("BG3", 0.75)
		




func _on_return_pressed():
	$AnimationPlayer.play("gg")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://Scenes/title_screen.tscn")
	global.ended = true
	global.is_retry = false
	global.diary_read = false
	global.puzzle_1_finished = false
	global.puzzle_2_finished = false
	global.current_puzzle = 1 
	global.dia_track = {}
	pass # Replace with function body.
