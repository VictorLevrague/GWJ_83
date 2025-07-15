extends Resource

class_name Character

@export var label_name: String
@export var illustration: Texture2D
@export var positive_actions: Array[Action]
@export var negative_actions: Array[Action]

func compute_sum_action_values() -> float:
    var sum_action_values := 0.
    for action in positive_actions:
        sum_action_values += action.value
    for action in negative_actions:
        sum_action_values -= action.value
    return sum_action_values

func sum_array(array: Array) -> float:
    return array.reduce(func(accum, number): return accum + number, 0)
