extends Control


@export var progress_bar_color: Color = Color.WHITE
@export var progress_bar_end: Color = Color.WHITE
@export var progress_bar_position: Control
var is_paused: bool = false

var chosen_time: float = 2.0
var current_time: float = 0.0
@export var label: Label
@export var progress_bar: TextureProgressBar
@onready var loop_counter: Label = $VBoxContainer/Timer/LoopCounter

var progress_angle: float = 0.0

var direction_multiplier: int = 1
var loop_offset: float = -90.0

var is_looping: bool = false
var times_looped: int = 0

var swapped_directions: bool = false


func _ready() -> void:
	current_time = chosen_time
	progress_bar.max_value = chosen_time
	
	loop_counter.text = ""


func _draw() -> void:
	var center: Vector2 = progress_bar_position.position
	var radius: float = 250.0
	var start_angle: float = 0 + deg_to_rad(loop_offset)
	var end_angle: float = progress_angle + deg_to_rad(loop_offset)
	var width: float = 20.0
	
	draw_arc(center, radius, start_angle, rad_to_deg(360.0), 100, Color.WHITE, width, true)
	draw_arc(center, radius, start_angle, end_angle, 100, progress_bar_color, width, true)
	
	var start_point: Vector2 = center + radius * Vector2(cos(start_angle), sin(start_angle))
	var end_point: Vector2 = center + radius * Vector2(cos(end_angle), sin(end_angle))
	
	draw_circle(start_point, width / 2.0, progress_bar_color)
	draw_circle(end_point, width / 2.0, progress_bar_end)


func _process(delta: float) -> void:
	queue_redraw()
	if !is_paused:
		if current_time > 0:
			current_time -= delta * direction_multiplier
			
			if current_time < 0:
				current_time = 0
			
			label.text = str("%.0f" % current_time)
			progress_bar.value = chosen_time - current_time
			if !swapped_directions:
				progress_angle = deg_to_rad(360.0 * (1.0 - (current_time / chosen_time)))
			else:
				progress_angle = deg_to_rad(-360.0 * ((current_time / chosen_time)))
		else:
			if is_looping:
				current_time = chosen_time
				
				swapped_directions = !swapped_directions
				
				times_looped += 1
				loop_counter.text = str(times_looped)
	
	if is_looping:
		loop_counter.visible = true
	else:
		loop_counter.visible = false


func stop_start() -> void:
	is_paused = !is_paused


func reset() -> void:
	current_time = chosen_time
	label.text = str("%.0f" % current_time)
	
	is_paused = true


func reverse() -> void:
	direction_multiplier = -direction_multiplier


func loop() -> void:
	is_looping = !is_looping
