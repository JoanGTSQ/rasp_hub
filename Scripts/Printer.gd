extends Module

const MODULE_NAME : String = "printer"
const WAIT_TIME_TIMER : float = 1.0
onready var animation_player = $AnimationPlayer
onready var _status_label_text = $Info/StatusLabelText setget _set_status_label_text, _get_status_label_text
onready var _total_time_text  = $Info/TotalTimeLabelText setget _set_total_time_text, _get_total_time_text


const api_url : String = "http://192.168.1.176:4409/printer/objects/query"


func _ready():
	start_module(MODULE_NAME, animation_player)
	var timer = Timer.new()
	timer.wait_time = WAIT_TIME_TIMER
	timer.one_shot = false
	timer.autostart = true
	# Añade el temporizador como hijo del nodo actual
	add_child(timer)
	
	# Conecta la señal timeout
	timer.connect("timeout", self, "_on_timer_timeout")

func _on_timer_timeout():
	_send_request()
	
func _set_status_label_text(_status : String) -> void:
	_status_label_text.text = _status

func _get_status_label_text() -> String:
	return _status_label_text.text


func _set_total_time_text(_total_time : String) -> void:
	_total_time_text.visible = true
	_total_time_text.text = _total_time + " min."


func _get_total_time_text() -> String:
	return _total_time_text.text

# Send the HTTP API request and call response function
func _send_request() -> void:
	# Crear un nodo HTTPRequest si no existe
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "_on_request_completed")
	# Headers
	var headers = ["Content-Type: application/json"]
	
	# Body
	var request_body = {
		"objects": {
			"print_stats": ["state", "total_duration", "print_duration", "filament_used"]
		}
	}
	
	# Enviar la solicitud con el método POST
	var error = http_request.request(
		api_url,
		headers,
		false,  # Usar SSL si es necesario
		HTTPClient.METHOD_POST,
		JSON.print(request_body)
	)
	
	if error != OK:
		print("Error al enviar la solicitud: ", error)

# Replace default _on_request_completed function
# Read the printer status and the job information
func _on_request_completed(result, response_code, _headers, body) -> void:
	if response_code == 200:
		var json = JSON.parse(body.get_string_from_utf8())
		if json.error == OK:
			var print_stats = json.result["result"]["status"]["print_stats"]
			print("Estado de impresión: ", print_stats["state"])
			_set_status_label_text(print_stats["state"])
			if print_stats["state"] == "printing":
				var total_duration : float = print_stats["total_duration"]
				var print_duration : float = print_stats["print_duration"]
				_set_total_time_text(str(stepify(total_duration/60, 0.01)))
#				print("Filamento usado: ", print_stats["filament_used"], " mm")
		else:
			print("Error al parsear JSON: ", json.error_string)
	else:
		print("Solicitud fallida. Código de respuesta: ", response_code)
