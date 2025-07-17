extends TextureButton

@export var next_scene: PackedScene

func _on_pressed() -> void:
    %Explanations.show()

func _on_mouse_entered() -> void:
    %ButtonLabel.modulate = Color(0., 0., 0.) 

func _on_mouse_exited() -> void:
    %ButtonLabel.modulate = Color(1.0, 1.0, 1.0)
