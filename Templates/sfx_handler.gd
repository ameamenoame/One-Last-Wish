extends Node2D

func play(sfx):
	get_node(sfx).play()
func stop(sfx):
	get_node(sfx).stop()