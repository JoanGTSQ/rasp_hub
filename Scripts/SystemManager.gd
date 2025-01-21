extends Node

onready var animation_player = $AnimationPlayer
onready var _cpu_label_info = $Info/CpuLabelInfo
onready var _ram_label_info = $Info/RamLabelInfo
onready var _os_label_info = $OsLabelInfo


var _cpu_info : String = ""
var _power_state : String = ""
var _os_name : String = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	ControlManager.connect("module_toggled", self, "_on_module_toggled")
	_cpu_info = OS.get_processor_name()
	if OS.get_power_state() != OS.POWERSTATE_NO_BATTERY:
		_power_state = str(OS.get_power_percent_left()) + "%"
	_os_name = OS.get_name()


func _on_module_toggled(_params : Dictionary) -> void:
	if _params.module == "system" and _params.status:
		_load_module()


func _process(delta):
	_ram_label_info.text = str(OS.get_dynamic_memory_usage())


func _load_module() -> void:
	animation_player.play("hover_in")
	_cpu_label_info.text = _cpu_info
	_os_label_info.text = _os_name + " " + _power_state


func _on_Close_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		animation_player.play("hover_out")
		ControlManager.emit_signal("toggle_module", {"module": "system", "status": false})
