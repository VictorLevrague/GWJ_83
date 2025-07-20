extends Resource

class_name Character

@export var label_name: String
@export var illustration: Texture2D
@export var positive_actions: Array[Action]
@export var negative_actions: Array[Action]

var used_action_text: Array[String]

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
        actions_pool.shuffle()
        actions_pool = actions_pool.filter(func(a): return not a.text in used_action_text)
        var selected_actions: Array[Action]
        if len(actions_pool) >= nb_actions:
            selected_actions = actions_pool.slice(0, nb_actions)
        else:
            selected_actions = actions_pool.slice(0, len(actions_pool))
        for action in selected_actions:
            var action_duplicate: Action = action.duplicate_custom()
            if inverse_output_arrays:
                action_duplicate.value = - action_duplicate.value
            output_action_array.append(action_duplicate)

func add_deadly_actions(nb_actions: int):
    if nb_actions: #maybe useless
        var output_action_array: Array[Action]
        var actions_pool: Array[Action] = ActionLibrary.deadly_actions_pool.duplicate()
        actions_pool.shuffle()
        for nb_action in nb_actions:
            var action: Action = actions_pool.pop_front()
            if action.automatic_destination == "heaven":
                output_action_array = positive_actions
            elif action.automatic_destination == "hell":
                output_action_array = negative_actions
            output_action_array.append(action)
