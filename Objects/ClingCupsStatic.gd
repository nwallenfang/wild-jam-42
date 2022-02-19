extends StaticBody

const interaction_text = "interact"

func start_interacting(_player: Player):
	get_parent().call("cling")
	
func stop_interacting():
	# do nothing
	pass
