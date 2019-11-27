extends Node2D

# reminder to make unique this script when creating a new scene

onready var smrt = get_node('CanvasLayer/SMRT')
onready var current_riddle = null
onready var riddles_solved = 0
onready var bg2 = load("res://Assets/BGs/bedroom screen w box 2.png")
# tracks what the cursor is interacting with
#func _process(delta):
#	get_node("Mouse").set_position(get_local_mouse_position())
		
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
#	get_node("Mouse").monitoring = false
	smrt.show_text(chapter, dialogue, start_at)
	yield(smrt, "finished")
	#starts artificial delay
	global.in_dialog = false
	get_node("Mouse/delay").start()

func  _physics_process(delta): 
	get_node("Mouse").set_position(get_local_mouse_position())
	# creates dialogue for an interactable object
	if Input.is_mouse_button_pressed(1) and global.int_able == true and global.current_npc != null and global.in_dialog == false and get_node("Mouse").monitoring == true: 
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
		if global.current_npc.get("dia_id") == "riddle_1" or global.current_npc.get("dia_id") == "riddle_2" or global.current_npc.get("dia_id") == "riddle_3" or global.current_npc.get("dia_id") == "bedroom_bookshelf" or global.current_npc.get("dia_id") == "bedroom_catalog" or global.current_npc.get("dia_id") == "bedroom_bed" or global.current_npc.get("dia_id") == "bedroom_drawings" or global.current_npc.get("dia_id") == "bedroom_desk" or global.current_npc.get("dia_id") == "bedroom_diary" or global.current_npc.get("dia_id") == "bedroom_pamphlet" or global.current_npc.get("dia_id") == "bedroom_lock" or global.current_npc.get("dia_id") == "doll_body_choice" or global.current_npc.get("dia_id") == "doll_head_choice":
			sfx_handler.play("button")
			if global.current_npc.get("dia_id") == "riddle_1" or global.current_npc.get("dia_id") == "riddle_2" or global.current_npc.get("dia_id") == "riddle_3":
				get_node("AnimationPlayer").play("riddle_field_slide_in")
				yield(get_node("AnimationPlayer"), "animation_finished")
#				get_node("riddle_field").set_editable(true)
				get_node("Mouse").monitoring = false
		# need check for multiple objects where the mouse was clicked
		
		
		# if want to do sth other than dialogue
		
		
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
#	global.int_able = true
#	current_npc = body
	
func uninteractable(body):
	print("int unable")
	Input.set_custom_mouse_cursor(null)
	global.current_npc = null
	print(global.current_npc)
#	global.int_able = false

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

#########################################################
#BELOW THIS IS WHERE YOU HANDLE HOW EACH SCENE PLAYS OUT#
#########################################################

# handles what happens when the scene starts
func _ready():
	get_node("BG").fade_out()
	music_handler.get_node("bgm").stop()
	music_handler.get_node("deeds_track").play()
	if global.is_retry:
		dia("puzzle_1", "1", 66)
	else:
		dia("puzzle_1", "1")

# mega-function for managing dynamic dialogue
func _on_SMRT_dialog_control(info):
	# let things happen on specific text, dialog points
	# Bookshelf
	
	if (info.chapter == "bedroom_catalog" and info.dialog == "1" and info.last_text_index == 50): #last_text_index starts at 0
		get_node("BG").fade_out("torn_page")
		yield($BG/Tween, "tween_completed")
		$return_button.visible = true
	elif (info.chapter == "puzzle_2" and info.dialog == "finished_1" and info.last_text_index == 9): #last_text_index starts at 0
		get_node("AnimationPlayer").play("doll_finished_fade_in")
	elif (info.chapter == "puzzle_2" and info.dialog == "finished_1" and info.last_text_index == 13): #last_text_index starts at 0
		get_node("AnimationPlayer").play_backwards("doll_finished_fade_in")
	elif (info.chapter == "puzzle_2" and info.dialog == "finished_1" and info.last_text_index == 28): #last_text_index starts at 0
		$BG.fade_in("whisper")
	elif (info.chapter == "puzzle_2" and info.dialog == "finished_1" and info.last_text_index == 41): #last_text_index starts at 0
		$BG.fade_in("whisper2")
	elif (info.chapter == "puzzle_2" and info.dialog == "finished_1" and info.last_text_index == 46): #last_text_index starts at 0
		$BG.fade_out("whisper2")


	elif (info.chapter == "puzzle_2" and info.dialog == "finished_2" and info.last_text_index == 7): #last_text_index starts at 0
		$BG.fade_in("head")
	elif (info.chapter == "puzzle_2" and info.dialog == "finished_2" and info.last_text_index == 16): #last_text_index starts at 0
		$BG.fade_out("head")




	
	elif (info.chapter == "puzzle_1" and info.dialog == "finished_1" and info.last_text_index == 2): #last_text_index starts at 0
		get_node("BG").fade_in("BG4")
	elif (info.chapter == "puzzle_1" and info.dialog == "finished_1" and info.last_text_index == 7): #last_text_index starts at 0
		get_node("BG").fade_out("BG4")
	elif (info.chapter == "puzzle_1" and info.dialog == "1" and info.last_text_index == 41): #last_text_index starts at 0
		get_node("BG").fade_in("mochi2")
	elif (info.chapter == "puzzle_1" and info.dialog == "1" and info.last_text_index == 46): #last_text_index starts at 0
		get_node("BG").fade_in("chief")
		get_node("BG").fade_out("mochi2")
		get_node("BG").fade_out("mochi")
	elif (info.chapter == "puzzle_1" and info.dialog == "1" and info.last_text_index == 65): #last_text_index starts at 0
		get_node("BG").fade_out("chief")						
	elif (info.chapter == "puzzle_1" and info.dialog == "finished_2" and info.last_text_index == 5): #last_text_index starts at 0
		get_node("AnimationPlayer").play("doll_finished_fade_in")
	elif (info.chapter == "puzzle_1" and info.dialog == "finished_2" and info.last_text_index == 10): #last_text_index starts at 0
		get_node("AnimationPlayer").play_backwards("doll_finished_fade_in")
	elif (info.chapter == "puzzle_1" and info.dialog == "finished_2" and info.last_text_index == 25): #last_text_index starts at 0
		$BG.fade_in("whisper")
	elif (info.chapter == "puzzle_1" and info.dialog == "finished_2" and info.last_text_index == 37): #last_text_index starts at 0
		$BG.fade_in("whisper2")
	elif (info.chapter == "puzzle_1" and info.dialog == "finished_2" and info.last_text_index == 42): #last_text_index starts at 0
		$BG.fade_out("whisper2")
	elif (info.chapter == "bedroom_bookshelf" and info.dialog == "1" and info.last_text_index == 3): #last_text_index starts at 0
		get_node("AnimationPlayer").play("books_fade_in")
		pass
	elif (info.chapter == "bedroom_pamphlet" and info.dialog == "1" and info.last_text_index == 2): #last_text_index starts at 0
		yield(get_tree(), "idle_frame")	
		if global.diary_read:
			dia("bedroom_pamphlet", "diary_read")
		else:
			dia("bedroom_pamphlet", "diary_unread")
	# begin mochi challange scene
	elif (info.chapter == "puzzle_1" and info.dialog == "1" and info.last_text_index == 8): #last_text_index starts at 0
		get_node("BG").fade_in("mochi")
		sfx_handler.play("floorboard")
	# mochi challenge ends
	elif (info.chapter == "puzzle_1" and info.dialog == "1" and info.last_text_index == 73): #last_text_index starts at 0
#		if not global.is_retry:
#			get_node("BG").fade_out("mochi", 0.5)
#			yield(get_node("BG/Tween"), "tween_completed")
		# start puzzle choice

		get_node("AnimationPlayer").play("choice_fade_in")
		#dia("puzzle_1", "2")
	# mochi lock box come on 
	elif (info.chapter == "puzzle_1" and info.dialog == "2" and info.last_text_index == 7):
		get_node("BG").fade_in("BG2")
		get_node("AnimationPlayer").play("fade_particle")
		get_node("Mouse").monitoring = false
	elif (info.chapter == "puzzle_1" and info.dialog == "2" and info.last_text_index == 27):
		get_node("BG").fade_out("BG2", 0.5)
		get_node("AnimationPlayer").play_backwards("fade_particle")
		yield(get_node("BG/Tween"), "tween_completed")
#		get_node("lock").visible = true
		get_node("lock/npc_int").monitorable = true
		get_node("AnimationPlayer").play("lock_slide_in")
		get_node("time_limit").start_time_limit()
		
	# clicking the clock icon 
	elif (info.chapter == "bedroom_lock" and ((info.dialog == "1" and info.last_text_index == 7) or (info.dialog == "2" and info.last_text_index == 0))):
		get_node("AnimationPlayer").play("password_field_slide_in")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("LineEdit").set_editable(true)
		get_node("Mouse").monitoring = false
	# puzzle 1 
	elif (info.chapter == "doll_body_choice" and info.dialog == "1" and info.last_text_index == 4):
		global.current_puzzle = 1
		get_node("AnimationPlayer").play_backwards("choice_fade_in")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("BG").fade_in("BG_box")
		get_node("BG/loop").set_texture(bg2)
		yield(get_tree(), "idle_frame")
		dia("puzzle_1", "2")
		pass
	# puzzle 2
	
	elif (info.chapter == "doll_head_choice" and info.dialog == "1" and info.last_text_index == 0):
		$BG.fade_in("chief")			
		$choice.visible = false
		$choice/doll_body.monitorable = false
		$choice/doll_head.monitorable = false
		
	elif (info.chapter == "doll_head_choice" and info.dialog == "1" and info.last_text_index == 15):
		global.current_puzzle = 2
		get_node("AnimationPlayer").play_backwards("choice_fade_in")
		yield(get_node("AnimationPlayer"), "animation_finished")
		# branching dialog 
		if (global.puzzle_1_finished == true):
			yield(get_tree(), "idle_frame")			
			dia("doll_head_choice", "2")
			yield(smrt, "finished")
			get_node("AnimationPlayer").play("riddles_fade_in")
			get_node("time_limit").start_time_limit()
		else: 
			yield(get_tree(), "idle_frame")
			dia("doll_head_choice", "3")
			yield(smrt, "finished")			
			get_node("AnimationPlayer").play("riddles_fade_in")
			get_node("time_limit").start_time_limit()
			
	
	elif (info.chapter == "riddle_1" and info.dialog == "1" and info.last_text_index == 0):
		current_riddle = 1
		get_node("riddle_field").set_editable(true)
#		get_node("AnimationPlayer").play("riddle_field_slide_in")
#		yield(get_node("AnimationPlayer"), "animation_finished")
#		get_node("riddle_field").set_editable(true)
#		get_node("Mouse").monitoring = false
	elif (info.chapter == "riddle_2" and info.dialog == "1" and info.last_text_index == 0):
		current_riddle = 2
		get_node("riddle_field").set_editable(true)
#		get_node("AnimationPlayer").play("riddle_field_slide_in")
#		yield(get_node("AnimationPlayer"), "animation_finished")
#		get_node("riddle_field").set_editable(true)
#		get_node("Mouse").monitoring = false
	elif (info.chapter == "riddle_3" and info.dialog == "1" and info.last_text_index == 3):
		current_riddle = 3
		get_node("riddle_field").set_editable(true)
#		get_node("AnimationPlayer").play("riddle_field_slide_in")
#		yield(get_node("AnimationPlayer"), "animation_finished")
#		get_node("riddle_field").set_editable(true)
#		get_node("Mouse").monitoring = false
		
		
	if (info.chapter == "bedroom_catalog" and info.dialog == "1" and info.last_text_index == 12):
		get_node("BG").fade_in("torn_page")
		$return_button.visible = false
	elif (info.chapter == "bedroom_diary" and info.dialog == "1" and info.last_text_index == 14):
		$AnimationPlayer.play("diary_page_fade_in")
		global.diary_read = true
		sfx_handler.play("page_turn")
	elif (info.chapter == "bedroom_diary" and info.dialog == "1" and info.last_text_index == 41):
		$AnimationPlayer.play_backwards("diary_page_fade_in")
		
	elif (info.chapter == "bedroom_diary" and info.dialog == "2" and info.last_text_index == 0): #last_text_index starts at 0
		$AnimationPlayer.play("diary_page_fade_in")		
		sfx_handler.play("page_turn")
	elif (info.chapter == "bedroom_diary" and info.dialog == "2" and info.last_text_index == 20):
		$AnimationPlayer.play_backwards("diary_page_fade_in")
		
		
# below is password handler functions
# player inputs the password
func _on_LineEdit_text_entered(new_text):
	print("Input: ", new_text)
	if (new_text == "1228"):
		print("unlocked")
		sfx_handler.play("unlock")
		sfx_handler.play("riddle_solved")
		get_node("AnimationPlayer").play_backwards("unlocked")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("LineEdit").queue_free()
		global.puzzle_1_finished = true
		get_node("time_limit").end_and_reset()
		if (global.puzzle_2_finished == true): #ENDING
			music_handler.get_node("deeds_track").stop()
			yield(get_tree(), "idle_frame")	
			music_handler.get_node("title").play()
			dia("puzzle_1", "finished_2")
			yield(smrt, "finished")
			get_node("BG").fade_in()
			yield(get_node("BG/action_tween"), "tween_completed")
			get_tree().change_scene("res://Scenes/ending.tscn")
			print("ending")
		elif (global.puzzle_2_finished == false):
			yield(get_tree(), "idle_frame")	
			dia("puzzle_1", "finished_1")
			yield(smrt, "finished")
			yield(get_tree(), "idle_frame")
			$BG.fade_in("chief")
			dia("puzzle_2", "p1_finished")
			yield(smrt, "finished")
			get_node("AnimationPlayer").play("riddles_fade_in")
			get_node("time_limit").start_time_limit()
		#stuff
	else:
		print("wrong password")
		dia("bedroom_lock", "wrong_password")
		get_node("LineEdit").release_focus()
		get_node("LineEdit").text = ""
		get_node("LineEdit/placeholder_Text").visible = true
		get_node("LineEdit").set_editable(false)
		get_node("AnimationPlayer").play_backwards("password_field_slide_in")
		get_node("Mouse").monitoring = true
	pass # Replace with function body.

#
#func _on_LineEdit_mouse_entered():
#	Input.set_custom_mouse_cursor(global.mouse_1)
#	pass # Replace with function body.
#
#
#func _on_LineEdit_mouse_exited():
#	Input.set_custom_mouse_cursor(null)
#	pass # Replace with function body.




func _on_LineEdit_focus_entered():
	get_node("LineEdit/placeholder_Text").visible = false
	pass # Replace with function body.


func _on_LineEdit_focus_exited():
	get_node("LineEdit/placeholder_Text").visible = true
	pass # Replace with function body.


func _on_riddle_field_text_entered(new_text):
	if current_riddle == 1:
		if (new_text.to_upper() == "LOVE"):
			get_node("riddles/riddle_1").dia_id = "riddle_solved"
			sfx_handler.play("riddle_solved")
			print("unlocked")
			riddles_solved += 1
			get_node("riddle_field").release_focus()
			get_node("riddle_field").text = ""
			get_node("riddle_field/placeholder_Text").visible = true
			get_node("riddle_field").set_editable(false)
			if riddles_solved != 3:
				dia("puzzle_2", "correct_answer")
				get_node("AnimationPlayer").play_backwards("riddle_field_slide_in")
				yield(get_node("AnimationPlayer"),"animation_finished")
			if riddles_solved == 3:
				get_node("AnimationPlayer").play("riddle_finished")
				get_node("time_limit").end_and_reset()
				$BG.fade_out("chief")
				global.puzzle_2_finished = true
				if global.puzzle_1_finished == false:
					print('idle frame plz')
					yield(get_tree(), "idle_frame")
					dia("puzzle_2", "finished_2")
					yield(smrt, "finished")
					yield(get_tree(), "idle_frame")
					get_node("BG").fade_in("BG_box")
					get_node("BG/loop").set_texture(bg2)
					dia("puzzle_1", "2")
				elif global.puzzle_1_finished == true: #ENDING
					music_handler.get_node("deeds_track").stop()				
					
					yield(get_tree(), "idle_frame")	
					music_handler.get_node("title").play()
					dia("puzzle_2", "finished_1")
					yield(smrt, "finished")
					get_node("BG").fade_in()
					yield(get_node("BG/action_tween"), "tween_completed")
					get_tree().change_scene("res://Scenes/ending.tscn")
					print("ending")
		else:
			print("wrong password")
			dia("puzzle_2", "wrong_answer")
			get_node("riddle_field").release_focus()
			get_node("riddle_field").text = ""
			get_node("riddle_field/placeholder_Text").visible = true
			get_node("riddle_field").set_editable(false)
			get_node("AnimationPlayer").play_backwards("riddle_field_slide_in")
	elif current_riddle == 2:
		if (new_text.to_upper() == "BOOK"):
			get_node("riddles/riddle_2").dia_id = "riddle_solved"
			sfx_handler.play("riddle_solved")
			print("unlocked")
			riddles_solved += 1
			get_node("riddle_field").release_focus()
			get_node("riddle_field").text = ""
			get_node("riddle_field/placeholder_Text").visible = true
			get_node("riddle_field").set_editable(false)
			if riddles_solved != 3:
				dia("puzzle_2", "correct_answer")
				get_node("AnimationPlayer").play_backwards("riddle_field_slide_in")
				yield(get_node("AnimationPlayer"),"animation_finished")
			if riddles_solved == 3:
				get_node("AnimationPlayer").play("riddle_finished")			
				$BG.fade_out("chief")				
				get_node("time_limit").end_and_reset()
				global.puzzle_2_finished = true				
				if global.puzzle_1_finished == false:
					print('idle frame plz')
					yield(get_tree(), "idle_frame")
					dia("puzzle_2", "finished_2")
					yield(smrt, "finished")
					yield(get_tree(), "idle_frame")
					get_node("BG").fade_in("BG_box")
					get_node("BG/loop").set_texture(bg2)
					dia("puzzle_1", "2")
				elif global.puzzle_1_finished == true: #ENDING
					music_handler.get_node("deeds_track").stop()				
	
					yield(get_tree(), "idle_frame")	
					dia("puzzle_2", "finished_1")
					music_handler.get_node("title").play()					
					yield(smrt, "finished")
					get_node("BG").fade_in()
					yield(get_node("BG/action_tween"), "tween_completed")
					get_tree().change_scene("res://Scenes/ending.tscn")
					print("ending")
		else:
			print("wrong password")
			dia("puzzle_2", "wrong_answer")
			get_node("riddle_field").release_focus()
			get_node("riddle_field").text = ""
			get_node("riddle_field/placeholder_Text").visible = true
			get_node("riddle_field").set_editable(false)
			get_node("AnimationPlayer").play_backwards("riddle_field_slide_in")
	elif current_riddle == 3:
		if (new_text.to_upper() == "LOCK"):
			get_node("riddles/riddle_3").dia_id = "riddle_solved"
			sfx_handler.play("riddle_solved")
			print("unlocked")
			riddles_solved += 1
			get_node("riddle_field").release_focus()
			get_node("riddle_field").text = ""
			get_node("riddle_field/placeholder_Text").visible = true
			get_node("riddle_field").set_editable(false)
			if riddles_solved != 3:
				dia("puzzle_2", "correct_answer")
				get_node("AnimationPlayer").play_backwards("riddle_field_slide_in")
				yield(get_node("AnimationPlayer"),"animation_finished")
			if riddles_solved == 3:
				get_node("AnimationPlayer").play("riddle_finished")
				$BG.fade_out("chief")				
				get_node("time_limit").end_and_reset()
				global.puzzle_2_finished = true				
				if global.puzzle_1_finished == false:
					print('idle frame plz')
					yield(get_tree(), "idle_frame")
					dia("puzzle_2", "finished_2")
					yield(smrt, "finished")
					yield(get_tree(), "idle_frame")
					get_node("BG").fade_in("BG_box")
					get_node("BG/loop").set_texture(bg2)
					dia("puzzle_1", "2")
				elif global.puzzle_1_finished == true: #ENDING
					music_handler.get_node("deeds_track").stop()
					yield(get_tree(), "idle_frame")	
					dia("puzzle_2", "finished_1")
					music_handler.get_node("title").play()					
					yield(smrt, "finished")
					get_node("BG").fade_in()
					yield(get_node("BG/action_tween"), "tween_completed")
					get_tree().change_scene("res://Scenes/ending.tscn")
					print("ending")
		else:
			print("wrong password")
			dia("puzzle_2", "wrong_answer")
			get_node("riddle_field").release_focus()
			get_node("riddle_field").text = ""
			get_node("riddle_field/placeholder_Text").visible = true
			get_node("riddle_field").set_editable(false)
			get_node("AnimationPlayer").play_backwards("riddle_field_slide_in")
	pass # Replace with function body.


func _on_riddle_field_focus_entered():
	get_node("riddle_field/placeholder_Text").visible = false
	pass # Replace with function body.


func _on_riddle_field_focus_exited():
	get_node("riddle_field/placeholder_Text").visible = true
	pass # Replace with function body.


func _on_return_button_pressed():
	if not global.in_dialog:
		get_node("return_button").release_focus()
		get_node("AnimationPlayer").play_backwards("books_fade_in")
		sfx_handler.play("button")
	else:
		get_node("return_button").release_focus()
	pass # Replace with function body.


func _on_time_limit_timeout():
	smrt.stop()
	music_handler.get_node("deeds_track").stop()
	global.is_retry = true
	global.diary_read = false
	global.puzzle_1_finished = false
	global.puzzle_2_finished = false
	global.current_puzzle = 1 
	global.dia_track = {}
	riddles_solved = 0
	get_node("AnimationPlayer").play("game_over")
	get_node("Mouse").monitoring = false
	yield(get_node("AnimationPlayer"), "animation_finished")
	yield(get_tree(), "idle_frame")
	dia("puzzle_fail", "1")
	yield(smrt, "finished")
	yield(get_tree().create_timer(2.5), "timeout")
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _on_return_button_riddle_pressed():
	if not global.in_dialog:
		get_node("return_button_riddle").release_focus()
		get_node("AnimationPlayer").play_backwards("riddle_field_slide_in")
		sfx_handler.play("button")
	else:
		get_node("return_button_riddle").release_focus()
	pass # Replace with function body.
