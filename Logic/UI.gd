extends CanvasLayer

signal text_done

onready var interaction_text_label = $Center/Crosshair/InteractionText
onready var lore_text = $Bottom/LoreText

var text_queue = []

func set_interaction_text(text: String):
	interaction_text_label.text = "[E] to " + text

func unset_interaction_text():
	interaction_text_label.text = ""
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lore_text.modulate.a = 0.0
	Game.CROSSHAIR = $Center/Crosshair
	var _e = connect("text_done", self, "text_done")


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


func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") \
	or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		var color_blended_out = Color(lore_text.modulate)
		color_blended_out.a = 0.0
		$TutorialTween.interpolate_property($Bottom/BeginInstructions, "modulate", null, color_blended_out, 0.5)
		$TutorialTween.start()
		self.set_process(false)  # don't check if inputs are made for the rest of the game..

func start_death_animation():
	pass
