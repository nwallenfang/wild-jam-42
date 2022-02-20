extends StaticBody

const interaction_text = "pull"

func start_interacting(_player: Player):
	get_parent().pull()
	
func stop_interacting():
	# do nothing
	pass
