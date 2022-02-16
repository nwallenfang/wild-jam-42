extends StaticBody

signal started_interacting


func start_interacting(player: Player):
	get_parent().call("start_interacting", player)
	
func stop_interacting():
	# do nothing
	pass
