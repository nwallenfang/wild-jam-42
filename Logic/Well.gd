extends Spatial


func _ready() -> void:
	$Player/PlayerMesh.visible = false
	
#	$RoomManager.rooms_convert()
#	$RoomManager.rooms_set_active(true)


func _on_DeathTrigger_body_entered(body: Node) -> void:
	if body is Player:
		# start end of the game
		UI.start_death_animation()

func _on_TripleRoomMainThemeSwitch_body_entered(body: Node) -> void:
	if body is Player:
		SoundManager.tween_to_main_theme(true)
		$SoundTriggers/TripleRoomMainThemeSwitch.set_deferred("monitoring", false)
		$SoundTriggers/TripleRoomMainThemeSwitch.set_deferred("monitorable", false)
