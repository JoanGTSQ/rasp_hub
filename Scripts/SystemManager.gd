extends Node

onready var animation_player = $AnimationPlayer
onready var cpu_label_info = $CpuLabelInfo
onready var ram_label_info = $RamLabelInfo
onready var os_label_info = $OsLabelInfo

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlManager.connect("module_toggled", self, "_on_module_toggled")

func _on_module_toggled(_params : Dictionary) -> void:
	if _params.module == "system" and _params.status:
		_load_module()

func _process(delta):
	ram_label_info.text = str(OS.get_dynamic_memory_usage())


func _load_module() -> void:
	animation_player.play("hover_in")
	cpu_label_info.text = OS.get_processor_name()
	var power_state : String = ""
	if OS.get_power_state() == OS.POWERSTATE_NO_BATTERY:
		power_state = "POTENCIA DIRECTA"
	else:
		power_state = str(OS.get_power_percent_left()) + "%"
	os_label_info.text = OS.get_name() + " " + power_state


func _on_Close_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		animation_player.play("hover_out")
		ControlManager.emit_signal("toggle_module", {"module": "system", "status": false})
