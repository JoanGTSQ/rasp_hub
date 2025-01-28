extends Module

const MODULE_NAME : String = "system"

onready var animation_player = $AnimationPlayer
onready var _cpu_label_info = $Info/CpuLabelInfo
onready var _ram_label_info = $Info/RamLabelInfo
onready var _os_label_info = $OsLabelInfo

var _cpu_info : String = ""
var _power_state : String = ""
var _os_name : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	start_module(MODULE_NAME, animation_player)
	_cpu_info = OS.get_processor_name()
	if OS.get_power_state() != OS.POWERSTATE_NO_BATTERY:
		_power_state = str(OS.get_power_percent_left()) + "%"
	_os_name = OS.get_name()


func _process(delta):
	_ram_label_info.text = str(OS.get_dynamic_memory_usage())
	
