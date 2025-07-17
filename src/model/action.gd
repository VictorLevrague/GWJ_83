extends Resource

class_name Action

@export var text: String #Or a more complex String type ?
@export var value: float
@export var is_value_visible: bool = false

func _init(_text: String, _value: float) -> void:
    text = _text
    value = _value
