extends Button

func _on_pressed() -> void:
    Signals.emit_signal("next_level")
