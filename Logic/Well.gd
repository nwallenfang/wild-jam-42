extends Spatial


func _ready() -> void:
	$Player/PlayerMesh.visible = false
	$RoomManager.rooms_convert()
	$RoomManager.rooms_set_active(true)


func _on_DeathTrigger_body_entered(body: Node) -> void:
	if body is Player:
		# start end of the game
		UI.start_death_animation()
