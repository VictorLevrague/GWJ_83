extends TextureButton

func _on_mouse_entered() -> void:
    if not disabled:
        var scale_tween = bounce_scale_tween(Vector2(1.2, 1.2), 240)


func _on_mouse_exited() -> void:
    var scale_tween = bounce_scale_tween(Vector2(1.0, 1.0), 255)

func bounce_scale_tween(scale_value: Vector2, color_value) -> Tween:
    var bounce_duration = 1.
    var tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, "scale", scale_value, bounce_duration)
    tween.set_parallel()
    tween.tween_property(self, "modulate", Color(color_value/255, 1, 1), bounce_duration)
    return tween

func _on_pressed() -> void:
    if not disabled:
        modulate = Color(1, 1, 1)
        var scale_tween = bounce_scale_tween(Vector2(1.0, 1.0), 255)
