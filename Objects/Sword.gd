extends Spatial

export var pullable := false

func _ready() -> void:
	if pullable:
		$Static.add_to_group("interactable")

var pull_state := 0
var pull_distance := .11

signal sword_pulled

func pull():
	if pull_state == 2:
		$Static.remove_from_group("interactable")
		$Tween.interpolate_property(self, "translation:y", translation.y, translation.y + pull_distance * 9, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween,"tween_all_completed")
		emit_signal("sword_pulled")
		play_idle_animation()
	else:
		$Static.remove_from_group("interactable")
		$Tween.interpolate_property(self, "translation:y", translation.y, translation.y + pull_distance, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween,"tween_all_completed")
		$Static.add_to_group("interactable")
		pull_state += 1

func play_idle_animation():
	$AnimationTween.interpolate_property(self, "rotation_degrees:y", 0, 360, 3)
	$AnimationTween.start()
	$AnimationPlayer.play("hover")

func play_hover_animation(up):
	for mesh in [$Blade, $Thing, $Cylinder, $Icosphere]:
		var current_hover_height = .1
		if !up:
			current_hover_height *= -1
		$HoverTween.interpolate_property(mesh, "translation:y", mesh.translation.y, mesh.translation.y + current_hover_height, 3, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$HoverTween.start()
