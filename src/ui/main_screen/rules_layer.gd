extends CanvasLayer

func _on_rules_button_pressed() -> void:
    hide()

func _input(event: InputEvent) -> void:
    if Input.is_action_pressed("ui_cancel"):
        show()

func _on_rules_opener_pressed() -> void:
    visible = not visible
