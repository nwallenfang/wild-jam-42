extends Node

#const default_volume := 0.0
# if we need more granularity we can do it like this
const default_volumes = {"MainTheme" : -6.9, "IntroAtmosphere" : 0.0} # , ...

onready var tween_out = $TweenOut
onready var tween_in = $TweenIn
var tween_out_current_player: AudioStreamPlayer
var tween_in_current_player: AudioStreamPlayer


# if we want to get right into action
const main_theme_intro_offset = 17.4
func switch_to_main_theme(skip_intro: bool):
	if skip_intro:
		$MainTheme.play(main_theme_intro_offset)
	else:
		$MainTheme.play(0)
		
func play_intro_atmosphere():
	$IntroAtmosphere.play()

func tween_out(player: AudioStreamPlayer, duration: float):
	tween_out_current_player = player
	tween_out.reset_all()
	tween_out.interpolate_property(player, "volume_db", player.volume_db, -80, duration, Tween.TRANS_CIRC, Tween.EASE_IN, 0)
	tween_out.start()
	
func tween_in(player: AudioStreamPlayer, duration: float):
	var default_volume = default_volumes[player.name]
	tween_in_current_player = player
	tween_in.reset_all()
	tween_in.interpolate_property(player, "volume_db", -80, default_volume, duration, Tween.TRANS_CIRC, Tween.EASE_IN, 0)
	player.play()
	tween_in.start()


func stop_intro_atmosphere():
	# player is past the intro area
	# slowly stop intro atmosphere
	tween_out($IntroAtmosphere, 3.0)
	# slowly start
	tween_in($MainTheme, 3.5)
	
func main_theme_to_vortex():
	tween_out($MainTheme, 2.0)
	# slowly start
	tween_in($VortexDrone, 3.5)


func _on_TweenOut_tween_all_completed() -> void:
	tween_out_current_player.playing = false


func _on_TweenIn_tween_all_completed() -> void:
	pass
