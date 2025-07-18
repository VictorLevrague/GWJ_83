extends HSlider

func _ready() -> void:
    value = AudioManager.get_node("%Music").volume_db

func _on_value_changed(value: float) -> void:
    AudioManager.get_node("%Music").volume_db = linear_to_db(value)
