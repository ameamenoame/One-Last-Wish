extends Timer

# artificial delay to prevent dialog spam
func _on_delay_timeout():
	if global.in_dialog == true:
		return
	else:
		get_parent().monitoring = true
		global.int_able = true
		global.in_dialog = false
	pass
