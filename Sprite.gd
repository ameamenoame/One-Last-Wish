extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	pass
# Called when the node enters the scene tree for the first time.
func popup():
	$Tween.interpolate_property(self, "opacity", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
func hide(): 
	$Tween.interpolate_property(self, "opacity", 0, 1, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
