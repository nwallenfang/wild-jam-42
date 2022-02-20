extends Spatial


func _ready() -> void:
	$Player/PlayerMesh.visible = false
	
#	$RoomManager.rooms_convert()
#	$RoomManager.rooms_set_active(true)


func _on_DeathTrigger_body_entered(body: Node) -> void:
	if body is Player:
		# start end of the game
		UI.start_death_animation()


func _on_IntroToWellArea_body_entered(body: Node) -> void:
	if body is Player:
		$SoundTriggers/IntroToWellArea.set_deferred("monitoring", false)
		$SoundTriggers/IntroToWellArea.set_deferred("monitorable", false)
		SoundManager.add_vortex_drone()

func _on_IntroToWellArea2_body_entered(body: Node) -> void:
	if body is Player:
		$SoundTriggers/IntroToWellArea2.set_deferred("monitoring", false)
		$SoundTriggers/IntroToWellArea2.set_deferred("monitorable", false)
		SoundManager.add_vortex_drone()

func _on_IntroToWellArea3_body_entered(body: Node) -> void:
	if body is Player:
		$SoundTriggers/IntroToWellArea3.set_deferred("monitoring", false)
		$SoundTriggers/IntroToWellArea3.set_deferred("monitorable", false)
		SoundManager.add_vortex_drone()

func _on_OutOfWellAreaTripleRoom_body_entered(body: Node) -> void:
	if body is Player:
		$SoundTriggers/OutOfWellAreaTripleRoom.set_deferred("monitoring", false)
		$SoundTriggers/OutOfWellAreaTripleRoom.set_deferred("monitorable", false)
		SoundManager.remove_vortex_drone()


func _on_OutOfWellArea_body_entered(body: Node) -> void:
	if body is Player:
		$SoundTriggers/OutOfWellArea.set_deferred("monitoring", false)
		$SoundTriggers/OutOfWellArea.set_deferred("monitorable", false)
		SoundManager.remove_vortex_drone()


func _on_TurnMainThemeOff_body_entered(body: Node) -> void:
	if body is Player:
		$SoundTriggers/TurnMainThemeOff.set_deferred("monitoring", false)
		$SoundTriggers/TurnMainThemeOff.set_deferred("monitorable", false)
		SoundManager.stop_main_theme_towards_end()
		SoundManager.remove_vortex_drone()


func _on_EndVortexDrone_body_entered(body: Node) -> void:
	if body is Player:
		# make vortex slowly louder
		SoundManager.vortex_drone_towards_end()
		$SoundTriggers/EndVortexDrone.set_deferred("monitoring", false)
		$SoundTriggers/EndVortexDrone.set_deferred("monitorable", false)
