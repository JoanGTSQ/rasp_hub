extends Node

export var MODULES : Dictionary = {"system": false, "weather": false, "security": false}

signal module_toggled(_params)
signal toggle_module(_params)
signal reload_modules(_params)

func _ready():
	OS.center_window()
	_load_configuration()
	connect("toggle_module", self, "_on_toggle_module")
	connect("reload_modules", self, "_on_reload_modules")


func _on_reload_modules(_params : Dictionary) -> void:
	for module in MODULES:
		emit_signal("module_toggled", {"module": module, "status": MODULES[module]})

func _on_toggle_module(_params : Dictionary) -> void:
	if _params.has("module") and _params.has("status"):
		var module : String = _params.module
		var status : bool = _params.status
		MODULES[module] = status
		emit_signal("module_toggled", {"module": module, "status": status})
		_save_configuration()
	else:
		print("Invalid paramenters on toggle module")


func _load_configuration() -> void:
	var file = File.new()
	if file.file_exists("res://modules_config.json"):
		file.open("res://modules_config.json", File.READ)
		var content = file.get_as_text()
		var json = JSON.parse(content)
		if json.error == OK and json.result is Dictionary:
			MODULES = json.result
		file.close()
	else:
		print("could not open modules config")


func _save_configuration() -> void:
	var file = File.new()
	if file.open("res://modules_config.json", File.WRITE) == OK:
		var content : String = JSON.print(MODULES)
		file.store_string(content)
		file.close()
	else:
		print("can not load de modules config files")
