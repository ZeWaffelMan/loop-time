extends CustomButton


@export var default_texture: Texture2D
@export var pressed_texture: Texture2D


func _ready() -> void:
	super._ready()
	icon = default_texture
	
	pressed.connect(switch_texture)


func switch_texture() -> void:
	if button_pressed:
		icon = pressed_texture
	else:
		icon = default_texture
