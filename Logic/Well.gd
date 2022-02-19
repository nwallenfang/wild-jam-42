extends Spatial


func _ready() -> void:
#	SoundManager.play_intro_atmosphere()
#	UI.queue_text("Message 1", 2.5)
#	UI.queue_text("Message 2", 2.5)
	$Player/PlayerMesh.visible = false


func _on_DeathTrigger_body_entered(body: Node) -> void:
	if body is Player:
		# start end of the game
		UI.start_death_animation()
