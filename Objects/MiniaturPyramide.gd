extends Spatial
class_name Pyramide

onready var big: MeshInstance = $"Pyramide Main"
onready var small: MeshInstance = $"Pyramide klein"

onready var entry: MeshInstance = $Cube
onready var waterL: MeshInstance = $"Brunnen L"
onready var waterR: MeshInstance = $"Brunnen R"
onready var garden_with_wall: MeshInstance = $Garten
onready var obelisk: MeshInstance = $Obelisk
onready var path: MeshInstance = $Cube001

var palms := []
var towers := []
var houses := []

signal build_done

var build_state := 0

func _ready() -> void:
	var all_children = get_children()
	for c in all_children:
		if c.name.begins_with("Palm"):
			palms.append(c)
		elif c.name.begins_with("Turm"):
			towers.append(c)
		elif c.name.begins_with("house"):
			houses.append(c)
	#palms.sort_custom(self, "x_translation_sort")
	palms.shuffle()
	hide_everything()
	#build_extras()

func hide_everything():
	for x in [big, small, entry, waterL, waterR, garden_with_wall, obelisk, path]:
		x.visible = false
	for xlist in [palms, towers, houses]:
		for x in xlist:
			x.visible = false

func build_pyramids():
	$Tween.start()
	$Tween.interpolate_property(big, "translation", big.translation + Vector3(0, -2, 0), big.translation, 2)
	big.translation = big.translation + Vector3(0, -2, 0)
	big.visible = true
	yield(get_tree().create_timer(.5), "timeout")
	$Tween.interpolate_property(small, "translation", small.translation + Vector3(0, -2, 0), small.translation, 2)
	small.translation = small.translation + Vector3(0, -2, 0)
	small.visible = true
	yield(get_tree().create_timer(1.3), "timeout")
	$Tween.interpolate_property(entry, "translation", entry.translation + Vector3(0, 0, -.5), entry.translation, 1)
	entry.translation = small.translation + Vector3(0, 0, -.5)
	entry.visible = true
	yield($Tween, "tween_all_completed")
	$Tween.remove_all()
	build_state = 1
	emit_signal("build_done")

func build_garden():
	$Tween.start()
	for x in [garden_with_wall]:
		$Tween.interpolate_property(x, "translation", x.translation + Vector3(0, -.2, 0), x.translation, 1)
		x.translation = x.translation + Vector3(0, -.2, 0)
		x.visible = true
	yield(get_tree().create_timer(1), "timeout")
	for t in towers:
		yield(get_tree().create_timer(.25), "timeout")
		$Tween.interpolate_property(t, "translation", t.translation + Vector3(0, .2, 0), t.translation, .8)
		t.translation = t.translation + Vector3(0, .2, 0)
		t.visible = true
		$Tween.start()
	yield(get_tree().create_timer(.2), "timeout")
	for x in [path]:
		$Tween.interpolate_property(x, "translation", x.translation + Vector3(0, -.2, 0), x.translation, .5)
		x.translation = x.translation + Vector3(0, -.2, 0)
		x.visible = true
	yield(get_tree().create_timer(.4), "timeout")
	for x in [obelisk]:
		$Tween.interpolate_property(x, "translation", x.translation + Vector3(0, -.2, 0), x.translation, 1.2, Tween.TRANS_BACK, Tween.EASE_OUT)
		$Tween.interpolate_property(x, "scale", Vector3(.5, .5, .5), x.scale * 1.5, 1.2, Tween.TRANS_BACK, Tween.EASE_OUT)
		x.translation = x.translation + Vector3(0, -.2, 0)
		x.scale = Vector3(.5, .5, .5)
		x.visible = true
		$Tween.start()
	yield($Tween, "tween_all_completed")
	$Tween.remove_all()
	build_state = 2
	emit_signal("build_done")

func build_extras():
	for w in [waterL, waterR]:
		yield(get_tree().create_timer(.3), "timeout")
		$Tween.interpolate_property(w, "translation", w.translation + Vector3(0, -.2, 0), w.translation, .5)
		w.translation = w.translation + Vector3(0, -.2, 0)
		w.visible = true
		$Tween.start()
	yield(get_tree().create_timer(.5), "timeout")
	call_deferred("parallel_build_palms")
	yield(get_tree().create_timer(.7), "timeout")
	call_deferred("parallel_build_houses")
	yield(get_tree().create_timer(.2), "timeout")
	yield($Tween, "tween_all_completed")
	$Tween.remove_all()
	build_state = 3
	emit_signal("build_done")

func parallel_build_palms():
	for t in palms:
		yield(get_tree().create_timer(.1), "timeout")
		$Tween.interpolate_property(t, "translation", t.translation + Vector3(0, .2, 0), t.translation, .8)
		$Tween.interpolate_property(t, "rotation_degrees:y", t.rotation_degrees.y - 90, t.rotation_degrees.y, .8)
		t.translation = t.translation + Vector3(0, .2, 0)
		t.rotation_degrees.y = t.rotation_degrees.y - 90
		t.visible = true
		$Tween.start()

func parallel_build_houses():
	for w in houses:
		yield(get_tree().create_timer(.25), "timeout")
		$Tween.interpolate_property(w, "translation", w.translation + Vector3(0, -.2, 0), w.translation, .5)
		w.translation = w.translation + Vector3(0, -.2, 0)
		w.visible = true
		$Tween.start()

func x_translation_sort(a, b):
	return a.translation.x < b.translation.x

const CRYSTAL = preload("res://Objects/Crystal.tscn")

func spawn_crystal():
	var crystal = CRYSTAL.instance()
	get_parent().add_child(crystal)
	crystal.translation = translation + Vector3(0,1,1.5)
	
	

