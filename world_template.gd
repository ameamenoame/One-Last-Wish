extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
onready var smrt = get_node('CanvasLayer/SMRT')
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print ('ye')
		dia("begin", "shit")
	pass
func dia(chapter, dialogue, start_at=0):
	global.char_movement = false
	global.int_able = false
	smrt.show_text(chapter, dialogue, start_at)
	yield(smrt, "finished")
	global.int_able = true
	global.char_movement = true

