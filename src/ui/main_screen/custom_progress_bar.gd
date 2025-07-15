extends ProgressBar

var ANIMATION_DURATION = 1

func set_and_animate(value: float):
    var tween = create_tween()
    tween.tween_property(self, "value", value, ANIMATION_DURATION)
