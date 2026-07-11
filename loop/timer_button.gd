extends Button


var default_scale: float = 1.0
var scale_amount: float = 0.1
var scale_speed: float = 40.0

var is_hovered: bool = false


func _ready() -> void:
	mouse_entered.connect(func(): is_hovered = true)
	mouse_exited.connect(func(): is_hovered = false)
	pressed.connect(punch_scale)
	default_scale = scale.x
	pivot_offset = size / 2


func _process(delta: float) -> void:
	if is_hovered:
		scale = lerp(scale, Vector2(default_scale + scale_amount, default_scale + scale_amount), scale_speed * delta)
	else:
		scale = lerp(scale, Vector2(default_scale, default_scale), scale_speed * delta)


func punch_scale() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(default_scale - scale_amount, default_scale - scale_amount), .025)
	tween.tween_property(self, "scale", Vector2(default_scale, default_scale), .025)
