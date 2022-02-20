extends Spatial


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sword.connect("sword_pulled", self, "sword_pulled")
	$Sword.connect("sword_slightly_pulled", self, "sword_slightly_pulled")
	
	
func sword_pulled():
	$Room3Message2.trigger_manually()
	$Crystal/MoveThis.add_to_group("interactable")
	
func sword_slightly_pulled():
	$Room3Message1.trigger_manually()
