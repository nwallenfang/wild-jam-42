extends Spatial


func _ready() -> void:
	$Crystal.get_node("MoveThis").remove_from_group("interactable")
	$Vase3/VaseCover.connect("was_opened", self, "was_opened")
	
	
func was_opened():
	$Crystal.get_node("MoveThis").add_to_group("interactable")
	$FairyDust.emitting = false

