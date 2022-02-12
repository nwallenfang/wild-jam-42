extends CSGBox




func _ready() -> void:
	pass # Replace with function body.

var push_depth = 0.3
func start_interacting():
	# move backward
	self.translate(push_depth * transform.basis.y)
	
func stop_interacting():
	self.translate(-push_depth * transform.basis.y)
