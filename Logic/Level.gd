extends Spatial


onready var label = $Bottom/LoreText



func _ready() -> void:
	yield(get_tree().create_timer(1.0), "timeout")
	UI.say_text("Lore Text 1", 3.0)
	yield(UI, "text_done")
	UI.say_text("Lore Text 2", 3.0)
