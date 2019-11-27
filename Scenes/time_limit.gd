extends Timer


func _ready():
	$Label.text = "Sam has 300 Seconds Left"
	
func _on_Timer_timeout():
	$Label.text = "Sam has %d Seconds Left" % ceil(self.time_left)
	pass # Replace with function body.
func start_time_limit():
	get_node("fade_in").play("fade_in")
	self.start()
	$Timer.start()
	
func end_and_reset():
	self.stop()
	self.wait_time = 300
	$Timer.stop()
	get_node("fade_in").play_backwards("fade_in")
	yield($fade_in, "animation_finished")
	$Label.text = "Sam has 300 Seconds Left"
	