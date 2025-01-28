extends Control

onready var performance_label : Label = $PerformanceLabel
onready var date_label : Label = $DateLabel
onready var system_button : Button = $SystemButton
onready var printer_button : Button = $PrinterButton

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlManager.connect("module_toggled", self, "_on_module_toggled")
	ControlManager.emit_signal("reload_modules", {})


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
		match _params.module:
			"system":
				system_button.visible = !_params.status
			"printer":
				printer_button.visible = !_params.status


func _on_system_button_pressed():
	ControlManager.emit_signal("toggle_module", {"module": "system", "status": true})


func _on_printer_button_pressed():
	ControlManager.emit_signal("toggle_module", {"module": "printer", "status": true})


func _on_weather_button_pressed():
	ControlManager.emit_signal("toggle_module", {"module": "weather", "status": true})
