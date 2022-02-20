extends CanvasLayer

signal text_done

onready var interaction_text_label = $Center/SelectionCrosshair/InteractionText
onready var lore_text = $Bottom/LoreText

var text_queue = []

func set_interaction_text(text: String):
	interaction_text_label.text = "[E] to " + text

func unset_interaction_text():
	if is_instance_valid(interaction_text_label):
		interaction_text_label.text = ""
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lore_text.modulate.a = 0.0
	var _e = connect("text_done", self, "text_done")
	
	
	# control ankh sprite size
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y
	
	for sprite in [$Ankh, $Credit1, $Credit2]:
		var scale = viewportWidth / sprite.texture.get_size().x
		sprite.set_position(Vector2(viewportWidth/2, viewportHeight/2))

		# set same scale value horizontally/vertically to maintain aspect ratio
		sprite.set_scale(Vector2(scale, scale))


var text_currently_showing = false
func show_text(text: String, duration: float):
	text_currently_showing = true
	lore_text.visible = true
	# set text
	lore_text.text = text
	# blend text in
	var color_blended_in = Color(lore_text.modulate)
	color_blended_in.a = 1.0
	$Tween.reset_all()
	$Tween.interpolate_property(lore_text, "modulate", null, color_blended_in, 0.6, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	# wait for the text duration to pass
	yield(get_tree().create_timer(duration), "timeout")
	
	# start fading out
	var color_blended_out = Color(lore_text.modulate)
	color_blended_out.a = 0.0
	$Tween.reset_all()
	$Tween.interpolate_property(lore_text, "modulate", null, color_blended_out, Tween.EASE_OUT, 0.5)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	text_currently_showing = false
	emit_signal("text_done")


func text_done():
	if not text_queue.empty():
		var queue_elem = text_queue.pop_front()
		show_text(queue_elem["text"], queue_elem["duration"])


func queue_text(text: String, duration: float):
	print("queue " + text)
	if text_currently_showing:
		text_queue.push_back({"text": text, "duration": duration})
	else:
		show_text(text, duration)

var current = "default"
func change_crosshair(name: String):
	if name != current:
		match name:
			"default":
				$Center/DefaultCrosshair.visible = true
				$Center/SelectionCrosshair.visible = false
			"selection":
				$Center/DefaultCrosshair.visible = false
				$Center/SelectionCrosshair.visible = true
		current = name


func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") \
	or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		var color_blended_out = Color(lore_text.modulate)
		color_blended_out.a = 0.0
		$TutorialTween.interpolate_property($Bottom/BeginInstructions, "modulate", null, color_blended_out, 0.5)
		$TutorialTween.start()
		self.set_process(false)  # don't check if inputs are made for the rest of the game..


func end_fizzle_with_tween():
	$EndFizzle.play(0.86)
	$SoundTween.interpolate_property($EndFizzle, "volume_db", -5.88, -80.0, 1.2, Tween.TRANS_CIRC, Tween.EASE_IN)
	$SoundTween.interpolate_property($EndFizzle, "volume_db", -5.88, -80.0, 1.2, Tween.TRANS_CIRC, Tween.EASE_IN)
	$SoundTween.start()
	


var voronoi_duration = 0.9
var ankh_show_duration = 0.4
var blended_in = Color(1.0, 1.0, 1.0, 1.0)
var blended_out = Color(1.0, 1.0, 1.0, 0.0)
func start_death_animation():
	# play end fizzle
	end_fizzle_with_tween()
	
	# stop drone
	SoundManager.remove_vortex_drone()
	
	
	$Center.visible = false
	$Bottom.visible = false
	$Center/DefaultCrosshair.visible = false
#	$Center/Crosshair.queue_free()
	
	$DeathTexture.visible = true
	var mat = $DeathTexture.material
	$Tween.interpolate_property(mat, "shader_param/threshold", 0.0, 1.0, voronoi_duration, Tween.EASE_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	
	# slowly show Ankh
#	var color_blended_out = Color(lore_text.modulate)
#	color_blended_out.a = 0.0
#	var color_blended_in = Color(lore_text.modulate)
#	color_blended_in.a = 1.0
	$DeathTexture.visible = false
	$Ankh.modulate = blended_out
	$Ankh.set_deferred("visible", true)
	$Tween.reset_all()
	$Tween.interpolate_property($Ankh, "modulate", blended_out, blended_in, ankh_show_duration, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	yield(get_tree().create_timer(3.8), "timeout")
	# show first credit scene
	$Tween.reset_all()
	$Tween.interpolate_property($Ankh, "modulate", blended_in, blended_out, 1.0, Tween.EASE_OUT)
	$Tween.start()
	
	
	$Credit1.modulate = blended_out
	$Credit1.set_deferred("visible", true)
	$Tween2.reset_all()
	$Tween2.interpolate_property($Credit1, "modulate", blended_out, blended_in, ankh_show_duration, Tween.EASE_IN)
	$Tween2.start()
	yield(get_tree().create_timer(10.0), "timeout")
	
	$Tween.reset_all()
	$Tween.interpolate_property($Credit1, "modulate", blended_in, blended_out, 1.0, Tween.EASE_OUT)
	$Tween.start()
	$Credit2.modulate = blended_out
	$Credit2.set_deferred("visible", true)
	$Tween2.reset_all()
	$Tween2.interpolate_property($Credit2, "modulate", blended_out, blended_in, ankh_show_duration, Tween.EASE_IN)
	$Tween2.start()

	yield(get_tree().create_timer(5.0), "timeout")
	
	
	# Fade to black
	$Tween.reset_all()
	$Tween.interpolate_property($Credit2, "modulate", blended_in, blended_out, 1.8, Tween.EASE_OUT)
	$Tween.start()

	yield($Tween, "tween_all_completed")
	
	get_tree().quit()

func _on_Button_pressed() -> void:
	start_death_animation()
