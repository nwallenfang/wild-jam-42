extends Spatial

func _ready() -> void:
	$Player/PlayerMesh.visible = false
	Game.CROSSHAIR = $UI/CenterContainer/Crosshair
