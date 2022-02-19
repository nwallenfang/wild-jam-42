extends StaticBody

const interaction_text = "build"

export(NodePath) var pyramide_path
var pyramide: Pyramide

func _ready() -> void:
	pyramide = get_node(pyramide_path)

func start_interacting(player: Player):
	pyramide = get_node(pyramide_path)
	remove_from_group("interactable")
	match pyramide.build_state:
		0:
			pyramide.build_pyramids()
		1:
			pyramide.build_garden()
		2:
			pyramide.build_extras()
	yield(pyramide, "build_done")
	if pyramide.build_state < 3:
		add_to_group("interactable")
	
func stop_interacting():
	pass
