extends Node

export var MODULES : Dictionary = {"system": false, "weather": false, "security": false}

signal module_toggled(_params)
signal toggle_module(_params)


func _ready():
	OS.center_window()
	connect("toggle_module", self, "_on_toggle_module")


func _on_toggle_module(_params : Dictionary) -> void:
	if _params.has("module") and _params.has("status"):
		var module : String = _params.module
		var status : bool = _params.status
		MODULES[module] = status
		emit_signal("module_toggled", {"module": module, "status": status})
	else:
		print("Invalid paramenters on toggle module")


func _load_configuration() -> void:
	pass


func _save_configuration() -> void:
	pass
