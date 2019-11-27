extends Node2D

var current_npc


signal changeWorld
#func  _physics_process(delta): 
#	# dialogue code
#	if Input.is_action_just_pressed("interact") and global.int_able == true and current_npc != null: 
#		print("interactable")
#		print (current_npc)
#		if current_npc.get("dia_flag") == true: 
#			print("body has dialogue, proceeds to chat")
#			if global.dia_track.has(current_npc.get("dia_id")) == false:
#				global.dia_track[current_npc.get("dia_id")] = 1
#				print("sucess")
#			get_parent().dia(current_npc.get("dia_id"), str(global.dia_track[current_npc.get("dia_id")]))
#			if global.dia_track[current_npc.get("dia_id")] < current_npc.get("max_dia"):
#				global.dia_track[current_npc.get("dia_id")] = global.dia_track[current_npc.get("dia_id")] + 1
#			print (global.dia_track)
#		pass
#	# change world code
#	if global.near_portal == true:
#		$popup.set_visible(true)
#		if Input.is_action_just_released("interact"):
#			print("change world")
#			$popup.set_visible(false)
#			emit_signal("changeWorld")
	

#func interactable(body):
#	print('int able')
#	Input.set_custom_mouse_cursor(mouse_0)
#	global.int_able = true
#	current_npc = body
#	pass # Replace with function body.
#
#
#func uninteractable(body):
#	print("int unable")
#	Input.set_custom_mouse_cursor(mouse_1)
#	current_npc = null
#	print(current_npc)
#	global.int_able = false
#	pass # Replace with function body.


	

