extends Sprite

#fade out a sprite
func fade_out(scene="transition", time=1.5):
	get_node("Tween").interpolate_property(get_node(scene), "modulate:a", 1.0, 0.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	get_node("Tween").start()

#fade in a sprite
func fade_in(scene="transition", time=1.5):
	if (scene != null):
		get_node(scene).z_index = 0
		get_node("action_tween").interpolate_property(get_node(scene), "modulate:a", 0.0, 1.0, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		get_node("action_tween").start()
	
