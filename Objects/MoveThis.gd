extends StaticBody

const interaction_text = "pick up"

func start_interacting(player: Player):
	get_parent().call("start_interacting", player)
	
func stop_interacting():
	# do nothing
	pass
