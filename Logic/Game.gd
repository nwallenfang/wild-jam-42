extends Node


const selection_crosshair = preload("res://Assets/Sprites/cross_selection.png")
const default_crosshair_black = preload("res://Assets/Sprites/crosshair_dark.png")
const default_crosshair_white = preload("res://Assets/Sprites/crosshair_white.png")
onready var CROSSHAIR: TextureRect

func change_crosshair(name: String):
	match name:
		"default":
			CROSSHAIR.texture = default_crosshair_black
		"selection":
#			CROSSHAIR.
			CROSSHAIR.texture = selection_crosshair
