extends Area2D
export(String, FILE, "*.tscn") var next_world
func _process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.get_name() == "Player":
			global.near_portal = true
		elif body.get_name() != "Player":
			global.near_portal = false
	pass
func change_world():
	global.near_portal = false
	get_tree().change_scene(next_world)
	print ("world changed")


func area_enter(area):
	print ("something enters")
	if area.get_name() == "player":
		global.near_portal = true
		print("player near portal")
	pass # Replace with function body.
