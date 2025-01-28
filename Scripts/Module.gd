extends Node
class_name Module

var _MODULE_NAME : String = ""
var _animation_player : AnimationPlayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlManager.connect("module_toggled", self, "_on_module_toggled")
	

func start_module(_module_name : String, _new_animation_player : AnimationPlayer) -> void:
	_MODULE_NAME = _module_name
	_animation_player = _new_animation_player


func _on_module_toggled(_params : Dictionary) -> void:
	if _params.module == _MODULE_NAME and _params.status:
		_load_module()


func _load_module() -> void:
	_animation_player.play("hover_in")
	pass


func _on_Close_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		_animation_player.play("hover_out")
		ControlManager.emit_signal("toggle_module", {"module": _MODULE_NAME, "status": false})
