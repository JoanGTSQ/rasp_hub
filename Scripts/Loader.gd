extends Control

var _hub_scene : String = "res://Scenes/Hub.tscn"

onready var _animation_player : AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	_animation_player.play("loader")
	ControlManager.connect("control_loaded", self, "_on_control_loaded")
	ControlManager.emit_signal("control_load", {})


func _on_control_loaded(_params : Dictionary) -> void:
	get_tree().change_scene(_hub_scene)


func _on_tree_exiting() -> void:
	_animation_player.stop(false)
