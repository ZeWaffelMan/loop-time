extends Control


@export var accent_color: Color = Color.WHITE

var default_timer_label_color: Color = Color.WHITE

var is_paused: bool = true
var chosen_time: float = 2.0
var current_time: float = 0.0

var is_looping: bool = false
var loop_offset: float = -90.0
var direction_multiplier: int = 1
var progress_angle: float = 0.0
var times_looped: int = 0
var swapped_directions: bool = false

@onready var timer_label: Label = $VBoxContainer/Timer/TimerLabel
@onready var loop_counter: Label = $VBoxContainer/Timer/LoopCounter
@onready var timer_anchor: Control = $TimerAnchor


func _ready() -> void:
	current_time = chosen_time
	default_timer_label_color = timer_label.modulate
	
	loop_counter.text = ""


func _draw() -> void:
	var center: Vector2 = timer_anchor.position
	var radius: float = 250.0
	var start_angle: float = 0 + deg_to_rad(loop_offset)
	var end_angle: float = progress_angle + deg_to_rad(loop_offset)
	var width: float = 20.0
	
	draw_arc(center, radius, start_angle, rad_to_deg(360.0), 100, Color.WHITE, width, true)
	draw_arc(center, radius, start_angle, end_angle, 100, accent_color, width, true)
	
	var start_point: Vector2 = center + radius * Vector2(cos(start_angle), sin(start_angle))
	var end_point: Vector2 = center + radius * Vector2(cos(end_angle), sin(end_angle))
	
	draw_circle(start_point, width / 2.0, accent_color)
	draw_circle(end_point, width / 2.0, accent_color)


func _process(delta: float) -> void:
	queue_redraw()
	if !is_paused:
		if current_time > 0:
			current_time -= delta * direction_multiplier
			
			timer_label.modulate = default_timer_label_color
			
			if current_time < 0:
				current_time = 0
				if !is_looping:
					timer_label.modulate = accent_color
			
			timer_label.text = str("%.0f" % current_time)
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
	timer_label.text = str("%.0f" % current_time)
	
	is_paused = true


func reverse() -> void:
	direction_multiplier = -direction_multiplier


func loop() -> void:
	is_looping = !is_looping
