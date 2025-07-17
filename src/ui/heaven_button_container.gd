extends Control

@onready var button = %HeavenButton

func _ready() -> void:
    button.pressed.connect(func(): Signals.emit_signal("send_to_heaven"))

func disable_button():
    button.disabled = true
    %WavingViewportContainer.material.set('shader_parameter/base_strength', 0)

func enable_button():
    button.disabled = false
    %WavingViewportContainer.material.set('shader_parameter/base_strength', 0.034)
