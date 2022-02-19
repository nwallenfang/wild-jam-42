extends StaticBody

const interaction_text = "interact"

func start_interacting(player: Player):
	get_parent().call("cling")
	
func stop_interacting():
	# do nothing
	pass
