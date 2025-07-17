extends Control

@onready var button = %HellButton

func _ready() -> void:
    button.pressed.connect(func(): Signals.emit_signal("send_to_hell"))

func disable_button():
    button.disabled = true
    button.material.set('shader_parameter/fire_strength', 0)

func enable_button():
    button.disabled = false
    button.material.set('shader_parameter/fire_strength', 0.4)
