extends StaticBody

const interaction_text = "open"

func start_interacting(player: Player):
	remove_from_group("interactable")
	get_parent().call("open")
	
func stop_interacting():
	# do nothing
	pass
