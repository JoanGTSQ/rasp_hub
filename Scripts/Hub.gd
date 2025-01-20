extends Control

onready var performance_label = $PerformanceLabel
onready var date_label = $DateLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlManager.connect("module_toggled", self, "_on_module_toggled")


func _process(delta):
	var time = OS.get_time()
	var hour = time["hour"]
	var minute = time["minute"]
	var second = time["second"]

	# Formatear la hora para pasarla a traducción (puedes ajustarlo según tu idioma y formato)
	var time_string = str(hour).pad_zeros(2) + ":" + str(minute).pad_zeros(2) + ":" + str(second).pad_zeros(2)
	
	performance_label.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	date_label.text = time_string


func _on_module_toggled(_params : Dictionary) -> void:
	if _params.has("module") and _params.has("status"):
		print(_params.module, " ", _params.status)


func _on_system_button_pressed():
	ControlManager.emit_signal("toggle_module", {"module": "system", "status": true})


func _on_security_button_pressed():
	ControlManager.emit_signal("toggle_module", {"module": "security", "status": true})


func _on_weather_button_pressed():
	ControlManager.emit_signal("toggle_module", {"module": "weather", "status": true})
