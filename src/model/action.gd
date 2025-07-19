extends Resource

class_name Action

@export var text: String #Or a more complex String type ?
@export var value: float
@export var is_value_visible: bool = false
@export var automatic_destination: String = ""

func _init(_text: String, _value: float, _automatic_destination: String = "") -> void:
    text = _text
    value = _value
    automatic_destination = _automatic_destination

func duplicate_custom() -> Action:
    var new_action = Action.new(text, value, automatic_destination)
    return new_action
