extends Sprite


#export(int) var SPEED = 50
#onready var WALK = Vector2(0, 0)
#var direction = 0
#func _ready():
#	if SPEED != 0:
#		print('npc moves')
#		$Timer.start()
#func _process(delta):
#	if SPEED != 0 and global.char_movement == true:
#		move_and_slide(WALK)
#func walk():
#	if direction == 0:
#		WALK.x = SPEED
#		direction = 1
#	elif direction == 1:
#		WALK.x = -SPEED
#		direction = 0
#	pass 
