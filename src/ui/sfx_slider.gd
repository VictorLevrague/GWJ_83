extends HSlider

func _ready() -> void:
    value = AudioManager.get_node("%Footstep").volume_db

func _on_value_changed(value: float) -> void:
    for audio_player in AudioManager.get_node("%Sfx").get_children():
        audio_player.volume_db *= linear_to_db(value)
