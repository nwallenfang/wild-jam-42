extends Spatial


onready var label = $UI/CenterContainer2/Label

signal text_done

func say_text(text, duration: float):
	# set text
	label.text = text
	# blend text in
	var color_blended_in = Color(label.modulate)
	color_blended_in.a = 1.0
	$Tween.reset_all()
	$Tween.interpolate_property(label, "modulate", null, color_blended_in, 0.8, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	# wait for the text duration to pass
	yield(get_tree().create_timer(duration), "timeout")
	
	# start fading out
	var color_blended_out = Color(label.modulate)
	color_blended_out.a = 0.0
	label.modulate.a = 0
	$Tween.reset_all()
	$Tween.interpolate_property(label, "modulate", null, color_blended_out, 0.5)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("text_done")

func _ready() -> void:
#	$Player/PlayerMesh.visible = true
	label.modulate.a = 0.0
	Game.CROSSHAIR = $UI/CenterContainer/Crosshair
	yield(get_tree().create_timer(1.0), "timeout")
	say_text("Lore Text 1", 3.0)
	yield(self, "text_done")
	say_text("Lore Text 2", 3.0)
