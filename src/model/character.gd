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

func add_actions(type: String, nb_actions: int, inverse_output_arrays: bool = false):
    if nb_actions: #maybe useless
        var actions_pool: Array[Action]
        var output_action_array: Array[Action]
        match type:
            "Positive":
                actions_pool = ActionLibrary.positive_action_pool.duplicate()
                output_action_array = positive_actions if not inverse_output_arrays else negative_actions
            "Negative":
                actions_pool = ActionLibrary.negative_action_pool.duplicate()
                output_action_array = negative_actions if not inverse_output_arrays else positive_actions
        if inverse_output_arrays:
            reverse_actions_value_signs(actions_pool)
        actions_pool.shuffle()
        if len(actions_pool) >= nb_actions:
            output_action_array.append_array(actions_pool.slice(0, nb_actions))
        else:
            output_action_array.append_array(actions_pool.slice(0, len(actions_pool)))

func reverse_actions_value_signs(array_action: Array[Action]) -> void:
    for action in array_action:
        action.value = - action.value
