extends Spatial


onready var house = $RoomList/House
onready var room1 = $RoomList/TripleRoom
onready var room2 = $RoomList/BigRoom
onready var room3 = $RoomList/WellRoom/Room3

func _ready() -> void:
	$Player/PlayerMesh.visible = false
	
#	$RoomManager.rooms_convert()
#	$RoomManager.rooms_set_active(true)

	# in the beginning only house has to visible, the others can be made invis
	room1.visible = false
	room2.visible = false
	room3.visible = false


func _on_DeathTrigger_body_entered(body: Node) -> void:
	if body is Player:
		# start end of the game
		UI.start_death_animation()


func _on_IntroToWellArea_body_entered(body: Node) -> void:
	if body is Player:
		$SoundTriggers/IntroToWellArea.set_deferred("monitoring", false)
		$SoundTriggers/IntroToWellArea.set_deferred("monitorable", false)
		SoundManager.add_vortex_drone()
		
		# Room 1 has to be made ready by now
		room1.visible = true
		
		# make house invis
		# to be safe we should introduce invis walls to curb backtracking
		house.visible = false

func _on_IntroToWellArea2_body_entered(body: Node) -> void:
	if body is Player:
		# make room1 invisible, only a psycho would go back now
		room1.visible = false
		
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


func _on_IntroToWellArea4_body_entered(body: Node) -> void:
	if body is Player:
		room2.visible = true
		$SoundTriggers/EndVortexDrone.set_deferred("monitoring", false)
		$SoundTriggers/EndVortexDrone.set_deferred("monitorable", false)


func _on_IntroToWellArea5_body_entered(body: Node) -> void:
	if body is Player:
		room2.visible = false
		room3.visible = true
		$SoundTriggers/EndVortexDrone.set_deferred("monitoring", false)
		$SoundTriggers/EndVortexDrone.set_deferred("monitorable", false)

