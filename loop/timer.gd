extends Control


var is_paused: bool = false

var chosen_time: float = 2.0
var current_time: float = 0.0
@onready var label: Label = $VBoxContainer/CenterContainer/Label

var direction_multiplier: int = 1

var is_looping: bool = false


func _ready() -> void:
	current_time = chosen_time


func _process(delta: float) -> void:
	if !is_paused:
		if current_time > 0:
			current_time -= delta * direction_multiplier
			
			if current_time < 0:
				current_time = 0
			
			label.text = str("%.2f" % current_time)
		else:
			if is_looping:
				current_time = chosen_time


func stop_start() -> void:
	is_paused = !is_paused


func reset() -> void:
	current_time = chosen_time
	label.text = str("%.2f" % current_time)
	
	is_paused = true


func reverse() -> void:
	direction_multiplier = -direction_multiplier


func loop() -> void:
	is_looping = !is_looping
