extends Node

#const default_volume := 0.0
# if we need more granularity we can do it like this
const default_volumes = {"MainTheme" : -12.9, "IntroAtmosphere" : 0.0, "VortexDrone": -4.0} # , ...

const reduced_main_theme = -17.0

var tween_out_current_player: AudioStreamPlayer
var tween_in_current_player: AudioStreamPlayer
var currently_playing: AudioStreamPlayer

# if we want to get right into action
const main_theme_intro_offset = 17.4
func switch_to_main_theme(skip_intro: bool):
	currently_playing = $MainTheme
	if skip_intro:
		$MainTheme.play(main_theme_intro_offset)

	else:
		$MainTheme.play(0)
		
func tween_to_main_theme(skip_intro: bool):
	var currently_playing_player = tween_in_current_player
	if currently_playing_player != null:
		tween_out(currently_playing_player, 1.5)
	if skip_intro:
		tween_in_with_offset($MainTheme, 2.1, main_theme_intro_offset)
	else:
		tween_in($MainTheme, 2.1)
		
func play_intro_atmosphere():
	$IntroAtmosphere.play()

func tween_out(player: AudioStreamPlayer, duration: float):
	tween_out_current_player = player
	$TweenOut.reset_all()
	$TweenOut.interpolate_property(player, "volume_db", player.volume_db, -80, duration, Tween.TRANS_CIRC, Tween.EASE_IN, 0)
	$TweenOut.start()
	
func tween_in(player: AudioStreamPlayer, duration: float):
	var default_volume = default_volumes[player.name]
	tween_in_current_player = player
	$TweenIn.reset_all()
	$TweenIn.interpolate_property(player, "volume_db", -80, default_volume, duration, Tween.TRANS_CIRC, Tween.EASE_IN, 0)
	player.play()
	$TweenIn.start()
	currently_playing = player
	
func tween_in_with_offset(player: AudioStreamPlayer, duration: float, offset: float):
	var default_volume = default_volumes[player.name]
	tween_in_current_player = player
	$TweenIn.reset_all()
	$TweenIn.interpolate_property(player, "volume_db", -80, default_volume, duration, Tween.TRANS_CIRC, Tween.EASE_IN, 0)
	player.play(offset)
	$TweenIn.start()
	currently_playing = player
	
func fade_out_for(duration: float):
	tween_out(currently_playing, 0.4)
	yield(get_tree().create_timer(duration), "timeout")
	tween_in(currently_playing, 0.4)


func stop_intro_atmosphere():
	# player is past the intro area
	# slowly stop intro atmosphere
	tween_out($IntroAtmosphere, 1.0)
	# slowly start
	tween_in($MainTheme, 1.5)
	
func add_vortex_drone():
	$TweenQuiet.reset_all()
	$TweenQuiet.interpolate_property($MainTheme, "volume_db", null, reduced_main_theme, 1.0, Tween.TRANS_CIRC, Tween.EASE_IN)
	$TweenQuiet.start()
	$TweenIn.reset_all()
	$TweenIn.interpolate_property($VortexDrone, "volume_db", -80, -4.0, 1.8, Tween.TRANS_CIRC, Tween.EASE_OUT, 0)
	$TweenIn.start()
	$VortexDrone.play()


func remove_vortex_drone():
	tween_out($VortexDrone, 3.0)
	$TweenQuiet.reset_all()
	$TweenQuiet.interpolate_property($MainTheme, "volume_db", reduced_main_theme, default_volumes["MainTheme"], 2.0, Tween.TRANS_CIRC, Tween.EASE_IN)
	$TweenQuiet.start()

func main_theme_to_vortex():
	tween_out($MainTheme, 2.0)
	# slowly start
	tween_in($VortexDrone, 3.5)


func stop_main_theme_towards_end():
	tween_out($MainTheme, 3.0)
	
func vortex_drone_towards_end():
	tween_in($VortexDrone, 4.0)


func _on_TweenOut_tween_all_completed() -> void:
	tween_out_current_player.stop()


func _on_TweenIn_tween_all_completed() -> void:
	pass
